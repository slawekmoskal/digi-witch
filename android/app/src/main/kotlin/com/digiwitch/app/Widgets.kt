package com.digiwitch.app

import android.app.AlarmManager
import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.BroadcastReceiver
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Matrix
import android.net.Uri
import android.view.View
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider
import org.json.JSONArray
import org.json.JSONObject
import java.text.SimpleDateFormat
import java.util.Calendar
import java.util.Date
import java.util.Locale

// Home-screen widgets: horoscope, card of the day, Moon (one theme each), plus two large
// ones: "Your day" (dated) and "Good thought" (no date, no birth date needed).
// The app writes a week of day texts ("days", JSON) plus today's card; each widget picks
// today's entry, so it stays right for days without opening the app.

private fun today() = SimpleDateFormat("yyyy-MM-dd", Locale.US).format(Date())

/** Today's entry, or null when the app has not been opened for over a week (or ever). */
private fun todayEntry(data: SharedPreferences): JSONObject? = try {
    val days = JSONArray(data.getString("days", "[]"))
    (0 until days.length()).map { days.getJSONObject(it) }
        .firstOrNull { it.getString("date") == today() }
} catch (_: Exception) {
    null
}

/** Opens the app at the widget's own place; the `homeWidget` query marks a widget tap. */
private fun open(context: Context, target: String): PendingIntent =
    HomeWidgetLaunchIntent.getActivity(
        context,
        MainActivity::class.java,
        Uri.parse("digiwitch://$target?homeWidget"),
    )

private fun RemoteViews.textOrGone(id: Int, text: String) {
    setTextViewText(id, text)
    setViewVisibility(id, if (text.isEmpty()) View.GONE else View.VISIBLE)
}

private fun SharedPreferences.text(key: String) = getString(key, "") ?: ""

/** A small bitmap of the card (upside down when reversed); widgets have a tight size limit. */
private fun cardPicture(context: Context, id: String, reversed: Boolean): Bitmap? = try {
    // The pictures ship inside the app, so any day's card shows without the app being opened.
    val full = context.assets.open("flutter_assets/assets/cards/$id.webp").use(BitmapFactory::decodeStream)
    val small = Bitmap.createScaledBitmap(full, 240, 240 * full.height / full.width, true)
    if (reversed) {
        Bitmap.createBitmap(
            small, 0, 0, small.width, small.height, Matrix().apply { postRotate(180f) }, true,
        )
    } else {
        small
    }
} catch (_: Exception) {
    null
}

private class DayCard(val name: String, val advice: String, val picture: Bitmap?)

/** Today's card when the app sent one for this date: turned in the app, or always in Pro. */
private fun dayCard(context: Context, data: SharedPreferences): DayCard? {
    val d = todayEntry(data) ?: return null
    val name = d.optString("cardName")
    if (name.isEmpty()) return null
    return DayCard(
        name, d.optString("cardAdvice"),
        cardPicture(context, d.optString("cardId"), d.optBoolean("cardReversed")),
    )
}

private val providers = arrayOf(
    HoroscopeWidgetProvider::class.java, CardWidgetProvider::class.java, MoonWidgetProvider::class.java,
    DayLargeWidgetProvider::class.java, ThoughtWidgetProvider::class.java,
)

/** Redraws every widget just after midnight, so the new day shows without opening the app. */
class MidnightReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val manager = AppWidgetManager.getInstance(context)
        for (p in providers) {
            val ids = manager.getAppWidgetIds(ComponentName(context, p))
            if (ids.isEmpty()) continue
            context.sendBroadcast(
                Intent(context, p).setAction(AppWidgetManager.ACTION_APPWIDGET_UPDATE)
                    .putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, ids),
            )
        }
    }
}

/** Called on every widget update; the update at midnight sets the alarm for the next one. */
private fun scheduleMidnight(context: Context) {
    val midnight = Calendar.getInstance().apply {
        add(Calendar.DAY_OF_YEAR, 1)
        set(Calendar.HOUR_OF_DAY, 0); set(Calendar.MINUTE, 0); set(Calendar.SECOND, 2); set(Calendar.MILLISECOND, 0)
    }.timeInMillis
    val intent = PendingIntent.getBroadcast(
        context, 0, Intent(context, MidnightReceiver::class.java),
        PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
    )
    // shortcut: an exact alarm needs a permission Play reserves for clock apps, so the system may
    // run this up to 10 minutes late; ask for SCHEDULE_EXACT_ALARM if that ever matters.
    (context.getSystemService(Context.ALARM_SERVICE) as AlarmManager)
        .setWindow(AlarmManager.RTC, midnight, 10 * 60 * 1000L, intent)
}

class HoroscopeWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
    ) {
        scheduleMidnight(context)
        val d = todayEntry(widgetData)
        val views = RemoteViews(context.packageName, R.layout.horoscope_widget).apply {
            // Love, work, energy as in the app's horoscope; 0 = the day has no meters.
            val love = d?.optInt("love", 0) ?: 0
            val metered = love > 0 && d!!.getString("text").isNotEmpty()
            setViewVisibility(R.id.w_meters, if (metered) View.VISIBLE else View.GONE)
            val cheer = d?.optString("cheer", "") ?: ""
            textOrGone(R.id.w_cheer, cheer)
            setInt(R.id.w_text, "setMaxLines", if (metered || cheer.isNotEmpty()) 2 else 3)
            if (metered) {
                fun meter(id: Int, label: String, key: String) {
                    val v = d!!.optInt(key, 0)
                    setTextViewText(id, "${widgetData.text(label)}\n${"●".repeat(v)}${"○".repeat(5 - v)}")
                    setContentDescription(id, "${widgetData.text(label)}: $v/5")
                }
                meter(R.id.w_love, "loveLabel", "love")
                meter(R.id.w_work, "workLabel", "work")
                meter(R.id.w_energy, "energyLabel", "energy")
            }
            when {
                d == null -> {
                    setTextViewText(R.id.w_head, "Digi Witch")
                    setTextViewText(R.id.w_text, widgetData.text("stale"))
                    textOrGone(R.id.w_caution, "")
                    textOrGone(R.id.w_foot, "")
                }
                d.getString("text").isEmpty() -> {
                    // No birth date yet: the Moon, and what a date would add.
                    setTextViewText(R.id.w_head, d.getString("label"))
                    setTextViewText(
                        R.id.w_text,
                        "${d.getString("phaseName")} · ${d.getString("moonIn")}",
                    )
                    textOrGone(R.id.w_caution, widgetData.text("needBirth"))
                    textOrGone(R.id.w_foot, "")
                }
                else -> {
                    setTextViewText(R.id.w_head, "${d.getString("sign")} · ${d.getString("label")}")
                    // The headline stands in for the day's line when there are meters.
                    textOrGone(R.id.w_text, if (metered && cheer.isNotEmpty()) "" else d.getString("text"))
                    // The meters take the caution's place; the weighted view keeps the footer down.
                    setTextViewText(
                        R.id.w_caution,
                        if (metered || cheer.isNotEmpty()) "" else d.getString("caution"),
                    )
                    setViewVisibility(R.id.w_caution, View.VISIBLE)
                    textOrGone(R.id.w_foot, "${d.getString("number")} · ${d.getString("color")}  ›")
                }
            }
            setOnClickPendingIntent(R.id.w_root, open(context, "horoscope"))
        }
        appWidgetIds.forEach { appWidgetManager.updateAppWidget(it, views) }
    }
}

class CardWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
    ) {
        scheduleMidnight(context)
        val card = dayCard(context, widgetData)
        val views = RemoteViews(context.packageName, R.layout.card_widget).apply {
            setTextViewText(R.id.w_card_title, widgetData.text("cardTitle").ifEmpty { "Karta dnia" })
            if (card?.picture != null) {
                setImageViewBitmap(R.id.w_card_img, card.picture)
            } else {
                setImageViewResource(R.id.w_card_img, R.drawable.widget_card_back)
            }
            setTextViewText(
                R.id.w_card_name,
                card?.name ?: widgetData.text("cardWaiting").ifEmpty { "Czeka na odsłonięcie" },
            )
            textOrGone(R.id.w_card_advice, card?.advice ?: "")
            setOnClickPendingIntent(R.id.w_root, open(context, "card"))
        }
        appWidgetIds.forEach { appWidgetManager.updateAppWidget(it, views) }
    }
}

class MoonWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
    ) {
        scheduleMidnight(context)
        val d = todayEntry(widgetData)
        val views = RemoteViews(context.packageName, R.layout.moon_widget).apply {
            setTextViewText(R.id.w_moon_icon, moonPhases[(d?.optInt("phase") ?: 0).coerceIn(0, 7)])
            setTextViewText(R.id.w_phase, d?.getString("phaseName") ?: "Digi Witch")
            setTextViewText(R.id.w_moon_in, d?.getString("moonIn") ?: widgetData.text("stale"))
            textOrGone(R.id.w_next, d?.getString("next") ?: "")
            textOrGone(R.id.w_mercury, d?.getString("mercury") ?: "")
            setOnClickPendingIntent(R.id.w_root, open(context, "moon"))
        }
        appWidgetIds.forEach { appWidgetManager.updateAppWidget(it, views) }
    }
}

private val moonPhases = arrayOf("🌑", "🌒", "🌓", "🌔", "🌕", "🌖", "🌗", "🌘")

/** The card of the day (or its back while it waits) and its name, for the large widgets. */
private fun RemoteViews.card(context: Context, data: SharedPreferences, withAdvice: Boolean) {
    val card = dayCard(context, data)
    if (card?.picture != null) {
        setImageViewBitmap(R.id.w_card_img, card.picture)
    } else {
        setImageViewResource(R.id.w_card_img, R.drawable.widget_card_back)
    }
    val name = card?.name ?: data.text("cardWaiting").ifEmpty { "Czeka na odsłonięcie" }
    setTextViewText(R.id.w_card_name, if (card != null && withAdvice) "$name\n${card.advice}" else name)
}

class DayLargeWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
    ) {
        scheduleMidnight(context)
        val d = todayEntry(widgetData)
        val views = RemoteViews(context.packageName, R.layout.day_large_widget).apply {
            val personal = d != null && d.getString("text").isNotEmpty()
            val metered = personal && d!!.optInt("love", 0) > 0
            setViewVisibility(R.id.w_meters, if (metered) View.VISIBLE else View.GONE)
            if (metered) {
                fun meter(id: Int, label: String, key: String) {
                    val v = d!!.optInt(key, 0)
                    setTextViewText(id, "${widgetData.text(label)}\n${"●".repeat(v)}${"○".repeat(5 - v)}")
                    setContentDescription(id, "${widgetData.text(label)}: $v/5")
                }
                meter(R.id.w_love, "loveLabel", "love")
                meter(R.id.w_work, "workLabel", "work")
                meter(R.id.w_energy, "energyLabel", "energy")
            }
            if (d == null) {
                setTextViewText(R.id.w_head, "Digi Witch")
                setTextViewText(R.id.w_cheer, widgetData.text("stale"))
                textOrGone(R.id.w_text, "")
                setTextViewText(R.id.w_line, "")
                textOrGone(R.id.w_moon, "")
                textOrGone(R.id.w_foot, "")
            } else {
                setTextViewText(
                    R.id.w_head,
                    if (personal) "${d.getString("sign")} · ${d.getString("label")}" else d.getString("label"),
                )
                // As in the app: good news from the reading first, else the kind message.
                val cheer = d.optString("support").ifEmpty { d.optString(if (personal) "cheer" else "moonCheer") }
                val message = d.optString("lead").ifEmpty { d.optString("message") }
                setTextViewText(R.id.w_cheer, message.ifEmpty { cheer })
                textOrGone(
                    R.id.w_text,
                    when {
                        message.isNotEmpty() && cheer.isNotEmpty() -> cheer
                        personal -> d.getString("text")
                        else -> widgetData.text("needBirth")
                    },
                )
                setTextViewText(R.id.w_line, if (personal && message.isNotEmpty()) d.getString("text") else "")
                val next = d.getString("next").ifEmpty { d.getString("moonIn") }
                textOrGone(R.id.w_moon, "${moonPhases[d.optInt("phase").coerceIn(0, 7)]} ${d.getString("phaseName")}\n$next")
                textOrGone(R.id.w_foot, if (personal) "${d.getString("number")} · ${d.getString("color")}" else "")
            }
            card(context, widgetData, withAdvice = false)
            setOnClickPendingIntent(R.id.w_root, open(context, "horoscope"))
        }
        appWidgetIds.forEach { appWidgetManager.updateAppWidget(it, views) }
    }
}

class ThoughtWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
    ) {
        scheduleMidnight(context)
        val d = todayEntry(widgetData)
        val views = RemoteViews(context.packageName, R.layout.thought_widget).apply {
            // As in the app: good news from the reading first, else the kind message, with
            // the other line under it. Never a date.
            val cheer = d?.optString("support").orEmpty()
                .ifEmpty { d?.optString("cheer").orEmpty() }.ifEmpty { d?.optString("moonCheer").orEmpty() }
            val headline = d?.optString("lead").orEmpty().ifEmpty { d?.optString("message").orEmpty() }
                .ifEmpty { cheer }.ifEmpty { widgetData.text("stale") }
            setTextViewText(R.id.w_cheer, headline)
            textOrGone(R.id.w_moon, if (cheer.isNotEmpty() && cheer != headline) cheer else "")
            card(context, widgetData, withAdvice = true)
            setOnClickPendingIntent(R.id.w_root, open(context, "card"))
        }
        appWidgetIds.forEach { appWidgetManager.updateAppWidget(it, views) }
    }
}
