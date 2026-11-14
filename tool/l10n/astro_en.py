"""Builds assets/content/en/astro.json: Polish structure and ids, English texts."""
import json, sys, copy, re, collections

T = {
"elements": {"fire": "Fire", "earth": "Earth", "air": "Air", "water": "Water"},
"compat": {
 "same": "The same element: you understand each other without words and move at a similar pace. Take care not to reinforce each other's weaknesses.",
 "supportive": "Elements that support each other: one kindles the other or gives it ground to stand on. You complement each other naturally.",
 "neutral": "Different elements, but with no conflict: each has its own world. The relationship calls for curiosity about what is different.",
 "tense": "Elements in tension: you have different needs and a different pace. That is no barrier, but it takes conversation and understanding, and you can learn a great deal from each other."},
"yearForecast": {
 "same": "This is your year, the year of your own sign (běnmìngnián). The tradition advises caution in it: more attentiveness, less risk. A good time to come back to yourself and your roots.",
 "friend": "The year of your “secret friend”. The tradition speaks of support that arrives quietly, so it is worth accepting help and invitations.",
 "trine": "The year of a sign from your trine of allies. It favours action, cooperation and carrying out plans; the energy of the year is close to yours.",
 "clash": "The year of your opposite sign (chōng). The tradition foretells changes and tensions. It is better not to force matters, and to treat change as an opportunity.",
 "neutral": "A neutral year for your sign. No particular tailwind and no obstacles: much depends on your own decisions."},
"chineseCompat": {
 "same": "The same sign: you understand each other well, but you also easily reinforce each other's weaknesses.",
 "friend": "Secret friends: according to the tradition this is one of the best pairings, each supporting the other.",
 "trine": "The same trine of allies: similar values and a natural harmony.",
 "clash": "Opposite signs: they attract and clash. A great deal to learn, but friction too.",
 "neutral": "A neutral pairing: no particular harmony and no conflict. Everything depends on the two of you."},
"haircut": {
 "waxing": "The Moon is waxing: according to tradition, hair grows back faster after a cut.",
 "waning": "The Moon is waning: according to tradition, a haircut keeps its shape longer."},
"week": {
 "same": "The Sun is now passing through a sign of your element. This is a week in which it is easier to be yourself and to carry out your plans. Use it for matters that call on your strengths.",
 "supportive": "The Sun is in a sign of an element that supports you. The week favours contacts, cooperation and new ideas: less resistance, more flow.",
 "neutral": "The Sun is in a sign of an element that is neutral for you. A calm week in which much depends on your consistency. Focus on one important matter.",
 "tense": "The Sun is in a sign of an element that moves to a different rhythm from yours. The week may call for patience and compromise. Do not force matters."},
"eclipseText": {
 "solar": "A solar eclipse falls at the new moon. In the tradition it is a powerful new beginning: a time for an intention that will matter for longer.",
 "lunar": "A lunar eclipse falls at the full moon. In the tradition it is a time of closure and of things coming to light: a good moment to bring something to an end."},
"phases": [
 ("New moon", "The new moon is a time for sowing. Set an intention and start something quietly. You do not have to show it to anyone yet."),
 ("Waxing crescent", "The Moon is growing and energy is building. A good time for first steps and for gathering what you need."),
 ("First quarter", "The first quarter brings the first obstacles. Do not give up: make a decision and act in spite of the resistance."),
 ("Waxing gibbous", "The Moon is almost full. Refine the details and fix what is not working. The result is close."),
 ("Full moon", "The full moon lights everything up and heightens emotions. You will see the results of what you have done. Celebrate, but do not decide on the spur of the moment."),
 ("Waning gibbous", "After the full moon comes a time for gratitude and sharing. Take stock of what you have learned."),
 ("Last quarter", "The last quarter is a time for clearing up. Let go of what you do not need: finish it, give it away, throw it out."),
 ("Waning crescent", "The Moon is fading before the new moon. Slow down, rest and grow quiet. A new cycle is about to begin.")],
"dayTypes": {
 "fire": ("Fruit day", "Moon in a Fire sign: in gardening tradition, a good day for fruiting plants and for picking fruit."),
 "earth": ("Root day", "Moon in an Earth sign: a good day for root vegetables, transplanting and working the soil."),
 "air": ("Flower day", "Moon in an Air sign: a good day for flowering plants and for cutting flowers for a vase."),
 "water": ("Leaf day", "Moon in a Water sign: a good day for herbs, salad leaves and watering.")},
"mercury": "Mercury retrograde: seen from Earth, it appears to move backwards across the sky. In astrological tradition this is a time for reviewing, correcting and returning to old matters, not for signing contracts in a hurry. Double-check messages and plans.",
"transits": {
 "moonInSun": "The Moon is in your Sun sign today. Emotions and needs are closer to the surface: a good day to do something for yourself.",
 "moonInMoon": "The Moon has returned to the sign it was in when you were born (a lunar return). The tradition speaks of a day of emotional renewal. Notice what you really need.",
 "moonInAsc": "The Moon is passing through the sign of your ascendant. What you feel shows more clearly, and others may pick up on it more easily today.",
 "moonOpposite": "The Moon is in the sign opposite your Sun. Tension between what you want and what others want comes more easily. Look for a compromise.",
 "sunSeason": "The Sun is in your sign: this is your time of year. A good moment to look back over the last year and set a new direction.",
 "mercuryInSun": "Mercury is retrograde in your Sun sign. Repetitions and misunderstandings may affect you more than others. Double-check what you say and what you sign."},
"rituals": {
 "new": ("New moon ritual", "The new moon is the start of the Moon's cycle, traditionally a time for sowing intentions. Sit quietly for a moment and write down what you want to begin or develop in yourself over the coming month.",
   ["What do I want to begin in this cycle?", "Which one small step will I take this week?", "What do I need in order to succeed?"]),
 "full": ("Full moon ritual", "The full moon is the peak of the cycle: a time for harvest, gratitude and letting go. Go back to your new moon intention and see what has happened.",
   ["What am I grateful for today?", "What has gone well since the new moon?", "What do I want to let go of before the new cycle begins?"])},
"today": {
 "same": ["The Moon is moving through a sign of your element today, and you feel more like yourself. Do things your own way and do not apologise for it.",
          "Today it is easier to trust your own instinct. A good day for matters that call on your natural strengths.",
          "The day's energy runs at your rhythm. Use it for something you have been putting off for a long time."],
 "supportive": ["The day is on your side: what you do meets less resistance than usual. A good moment for conversations and new contacts.",
          "The people around you are supportive today. Ask for help or suggest working together, and you will hear “yes” more often than usual.",
          "A light, favourable day. Go for movement, an exchange of ideas and small pleasures."],
 "neutral": ["A calm day with no clear winds: how much you get out of it is up to you. Focus on one concrete thing.",
          "Nothing is pushing you in any direction today. A good moment to put your affairs in order calmly.",
          "An ordinary day in which consistency counts. Small steps will achieve more than grand gestures."],
 "tense": ["Today you may feel that the world is playing to a different rhythm from yours. Do not fight it: slow down and choose which matters really are important.",
          "A tense day, when misunderstandings come easily. Before you answer sharply, take a breath.",
          "The day's energy is foreign to you, which can be tiring. Look after yourself and do not make big decisions on the strength of a mood."]},
"caution": {
 "1": "Watch out for stubbornness and going it alone. You do not have to do everything yourself.",
 "2": "Watch out for giving way too much. Your opinion counts too.",
 "3": "Watch out for scattering your attention and for empty promises. Finish what you have started.",
 "4": "Watch out for rigidity. The plan matters, but leave room for change.",
 "5": "Watch out for hasty decisions and impulse spending.",
 "6": "Watch out for taking on other people's problems. Help, but do not rescue anyone against their will.",
 "7": "Watch out for withdrawing into yourself and overanalysing.",
 "8": "Watch out for overwork and the fight for control. Rest is productive too.",
 "9": "Watch out for holding on to what is already over. Let it go."},
"elements5": {
 "wood": ("Wood", "Wood", "Wood is growth, generosity and cooperation. Wood people grow together with others and think about the future."),
 "fire": ("Fire", "Fire", "Fire is passion, enthusiasm and courage. Fire people spread their energy to others, but burn out easily."),
 "earth": ("Earth", "Earth", "Earth is stability, good sense and care. Earth people are a support to others and build to last."),
 "metal": ("Metal", "Metal", "Metal is determination, principles and willpower. Metal people are consistent and not afraid of hard decisions."),
 "water": ("Water", "Water", "Water is intuition, flexibility and wisdom. Water people adapt to circumstances and read others well.")},
"signs": {
 "aries": ("Aries", "Aries is the first sign of the zodiac and fire in its purest form: courage, initiative and a need to act here and now. Aries is happiest when starting something; patience and finishing come harder.", "red", "diamond, carnelian", "Tuesday", "Mars",
   "In love Aries is direct and passionate: Aries enjoys the chase and shows feelings quickly. Aries needs a partner who is not afraid of the pace, and learns that closeness takes patience too.",
   "At work Aries does best where initiative counts: starting projects, leading, competing. Routine is tiring; it helps to have someone alongside who will finish the details.",
   "Aries works off energy through movement. Sport, short intense challenges and consciously putting on the brakes before tiredness turns into irritation all help."),
 "taurus": ("Taurus", "Taurus is earth that values calm, comfort and what lasts. Taurus is patient and faithful, and builds slowly but solidly. The challenge can be stubbornness and a reluctance to change.", "green, pink", "emerald, rose quartz", "Friday", "Venus",
   "In love Taurus is faithful, tender and sensual. Taurus shows feelings through actions, such as care, a meal, simply being there, and needs a sense of constancy.",
   "At work Taurus is persistent and reliable, and sees things through. Taurus is at home in finance, craft, gardening and anywhere the result can be seen.",
   "Nature, good food and a daily rhythm do Taurus good. Stagnation is the thing to watch: gentle movement and a change of scene bring back lightness."),
 "gemini": ("Gemini", "Gemini is air in motion: curiosity, conversation, quick connections between facts. Gemini makes contact easily and picks up new things fast. The challenge is distraction and difficulty choosing one path.", "yellow", "agate, citrine", "Wednesday", "Mercury",
   "In love Gemini needs conversation and lightness. Gemini falls in love with a mind; boredom is the greatest threat to the relationship.",
   "At work Gemini shines in communication, media, trade and teaching. Gemini likes many projects at once; the key is choosing priorities.",
   "The mind never stops working, so Gemini needs moments of quiet and time offline. Breathing, a walk and fewer stimuli in the evening all help."),
 "cancer": ("Cancer", "Cancer is water that protects: home, loved ones, a sense of safety. Cancer is sensitive and caring, with a good emotional memory. The challenge is retreating into the shell when something hurts.", "silver, white", "pearl, moonstone", "Monday", "the Moon",
   "In love Cancer is caring and devoted, and makes a home in which loved ones feel safe. Cancer needs reassurance and tenderness, though does not always ask for them.",
   "At work Cancer does well wherever care matters: in caring professions, education, food and work with people. Cancer works well in teams that feel like a family.",
   "Cancer's wellbeing depends heavily on emotions. Home, water, close people and naming feelings, instead of hiding them in the shell, all help."),
 "leo": ("Leo", "Leo is fire that shines: generosity, creativity and a need to be noticed. Leo gives others warmth and courage. The challenge can be pride and difficulty accepting criticism.", "gold, orange", "ruby, amber", "Sunday", "the Sun",
   "In love Leo is generous, romantic and loyal. Leo needs admiration and appreciation, and gives a great deal of warmth in return.",
   "At work Leo likes to lead and to perform, and does well in leadership, the arts, sales and anywhere there is a chance to stand out.",
   "Leo draws energy from joy and creativity. It is worth looking after the heart and spine, figuratively too: taking a rest from the role of “the strong one”."),
 "virgo": ("Virgo", "Virgo is earth in the details: order, reliability and a wish to be helpful. Virgo sees what could be improved. The challenge is perfectionism and judging oneself too harshly.", "beige, navy blue", "sapphire, jasper", "Wednesday", "Mercury",
   "In love Virgo shows feelings through care and help. Virgo can be reserved but is deeply devoted, and needs a partner who appreciates that everyday attentiveness.",
   "At work Virgo is precise, analytical and reliable, and does well in health, analysis, editing and organisation: anywhere the details count.",
   "Virgo worries easily, so order, routine and consciously letting go of perfectionism help. Virgo responds well to a healthy diet and walks."),
 "libra": ("Libra", "Libra is air that seeks balance: harmony, fairness and beauty in relationships. Libra knows how to calm disputes. The challenge is putting off decisions so as not to offend anyone.", "pastel blue, pink", "opal, lapis lazuli", "Friday", "Venus",
   "In love Libra looks for partnership, harmony and beauty. Libra is romantic and tactful, but has to take care not to give up on themselves for the sake of peace.",
   "At work Libra does well in diplomacy, law, design and work with clients. Libra works best in a pair or a team.",
   "Beautiful surroundings, art and a balance between work and rest do Libra good. Conflict is draining, so it is worth learning to say “no”."),
 "scorpio": ("Scorpio", "Scorpio is deep water: intensity, loyalty and insight. Scorpio is never satisfied with the surface. The challenge can be jealousy and difficulty letting go.", "burgundy, black", "topaz, obsidian", "Tuesday", "Mars and Pluto",
   "In love Scorpio is intense, passionate and loyal to the end. Scorpio needs deep trust and finds betrayal very hard to forgive.",
   "At work Scorpio is perceptive and persistent, and does well in research, psychology, finance, medicine and anywhere you have to get to the heart of the matter.",
   "Strong emotions are better worked through than suppressed. Intense exercise, water and a conversation with someone trusted all help."),
 "sagittarius": ("Sagittarius", "Sagittarius is fire in search of meaning: travel, knowledge, freedom and optimism. Sagittarius spreads enthusiasm. The challenge is impatience and promises made too quickly.", "purple", "turquoise, amethyst", "Thursday", "Jupiter",
   "In love Sagittarius needs freedom and shared adventure. Sagittarius is honest, warm and optimistic, and copes badly with jealousy and control.",
   "At work Sagittarius does well in travel, education, publishing, sport and anywhere there is meaning and room to grow.",
   "Movement and space give Sagittarius energy: hiking, sport, new places. Excess is the thing to watch, in food, in promises and in pace."),
 "capricorn": ("Capricorn", "Capricorn is earth climbing to the summit: ambition, responsibility and perseverance. Capricorn thinks long term. The challenge is work at the cost of rest and closeness.", "brown, grey", "garnet, onyx", "Saturday", "Saturn",
   "In love Capricorn is serious, responsible and loyal. Capricorn shows feelings by caring for the future, and needs time to open up.",
   "At work Capricorn is ambitious, persistent and well organised, and does well in management, finance, administration and long-term projects.",
   "Capricorn easily overworks at the cost of rest. A regular rhythm, mountains, silence and allowing oneself pleasure without guilt all help."),
 "aquarius": ("Aquarius", "Aquarius is air that looks to the future: independence, originality and thinking about the community. Aquarius likes to go their own way. The challenge is emotional distance.", "turquoise", "amethyst, aquamarine", "Saturday", "Saturn and Uranus",
   "In love Aquarius needs friendship and freedom. Aquarius is loyal and open, but shows emotion in their own way, more through shared ideas than tender words.",
   "At work Aquarius does well in technology, science, community work and anywhere new solutions can be invented.",
   "The head works fast and the body tends to be forgotten. Movement, contact with people who share the same values and time for personal projects all help."),
 "pisces": ("Pisces", "Pisces is water without shores: empathy, imagination and spirituality. Pisces feels more than Pisces says. The challenge is escaping from reality and a lack of boundaries.", "sea green, lavender", "aquamarine, amethyst", "Thursday", "Jupiter and Neptune",
   "In love Pisces is romantic, empathetic and devoted. Pisces falls in love easily and idealises, and needs a partner who gives a sense of safety.",
   "At work Pisces does well in the arts, helping others, therapy, music and spirituality: wherever imagination and compassion count.",
   "Pisces absorbs the moods of the surroundings, so needs quiet and boundaries. Water, sleep, art and less contact with whatever is overwhelming all help.")},
"chinese": {
 "rat": ("Rat", "Quick-witted, resourceful and sociable; quick to spot an opportunity.",
   "The Rat opens the Chinese zodiac. It is the sign of cleverness, resourcefulness and quick thinking, able to see an opportunity where others see a problem. The Rat is sociable and at ease among people, though chooses close friends with care. The challenge: nervousness and a tendency to hoard “just in case”.",
   "In love the Rat is tender and devoted, though cautious at first. The Rat values a partner who is bright and loyal.",
   "At work the Rat does well in business, trade and anywhere an opportunity has to be spotted quickly."),
 "ox": ("Ox", "Patient, hard-working and dependable; reaches the goal step by step.",
   "The Ox is diligence, patience and dependability. The Ox works methodically and dislikes haste and surprises, but keeps a promise once it is made. The challenge: stubbornness and difficulty asking for help.",
   "In love the Ox is faithful and steady, showing feelings through actions rather than words.",
   "At work the Ox is dependable and does well in jobs that call for patience, precision and responsibility."),
 "tiger": ("Tiger", "Brave, full of energy and independent; not afraid of a challenge.",
   "The Tiger is courage, energy and a need for independence. The Tiger enjoys challenges and stands up for the weaker. The Tiger can be hot-headed and impatient, but that enthusiasm carries others along.",
   "In love the Tiger is passionate and spontaneous, and needs a partner who gives space.",
   "At work the Tiger is at home as a leader, an entrepreneur or wherever courage counts."),
 "rabbit": ("Rabbit", "Gentle, tactful and sensitive to beauty; values peace.",
   "The Rabbit (the Cat in Vietnam) is tact, gentleness and a feeling for beauty. The Rabbit avoids conflict and values peace and good relationships. The challenge: avoiding hard decisions and being overcautious.",
   "In love the Rabbit is tender and romantic, and looks for a calm, harmonious relationship.",
   "At work the Rabbit does well in diplomacy, the arts, design and work with people."),
 "dragon": ("Dragon", "Charismatic, ambitious and self-assured; likes big plans.",
   "The Dragon is the only mythical animal in the zodiac, a symbol of power, good fortune and charisma. The Dragon has big plans and the energy to carry them out. The challenge: pride and impatience with other people's weaknesses.",
   "In love the Dragon is passionate and generous, but needs admiration and freedom.",
   "At work the Dragon aims for great goals and does well in leadership and large-scale projects."),
 "snake": ("Snake", "Wise, intuitive and thoughtful; sees more than it shows.",
   "The Snake is wisdom, intuition and elegance. The Snake thinks before acting and sees more than it says. The challenge: secretiveness and suspicion.",
   "In love the Snake is sensual and loyal, but jealous of what matters.",
   "At work the Snake does well in analysis, strategy, finance and anywhere insight counts."),
 "horse": ("Horse", "A free spirit, energetic and honest; needs movement and space.",
   "The Horse is a free spirit: energy, honesty and a need for movement. The Horse likes to be at the centre of things and acts fast. The challenge: impatience and difficulty finishing what has been started.",
   "In love the Horse is honest and enthusiastic, and needs shared adventures and freedom.",
   "At work the Horse is happiest on the move: in travel, sales, sport and fast-paced projects."),
 "goat": ("Goat", "Creative, gentle and empathetic; at ease in harmony.",
   "The Goat (or Sheep) is creativity, gentleness and empathy. The Goat needs harmony and safe surroundings in order to flourish. The challenge: worrying and depending on other people's opinions.",
   "In love the Goat is gentle and caring, and needs security and tenderness.",
   "At work the Goat does well in the arts, care, creative work and teams with a good atmosphere."),
 "monkey": ("Monkey", "Inventive, witty and curious about the world; a fast learner.",
   "The Monkey is inventiveness, wit and curiosity about the world. The Monkey learns fast and finds unusual solutions. The challenge: distraction and a tendency to take shortcuts.",
   "In love the Monkey is fun and inventive, and treats boredom as the worst enemy.",
   "At work the Monkey does well in technology, trade, entertainment and anywhere unconventional thinking is needed."),
 "rooster": ("Rooster", "Hard-working, honest and precise; likes order and clear rules.",
   "The Rooster is honesty, diligence and attention to detail. The Rooster likes order and says plainly what it thinks. The challenge: being critical and perfectionism.",
   "In love the Rooster is faithful and caring, though sometimes critical, and expresses feelings through attention to detail.",
   "At work the Rooster does well in organisation, accounting, the military, medicine and jobs that require precision."),
 "dog": ("Dog", "Loyal, honest and protective; takes the side of the weaker.",
   "The Dog is loyalty, honesty and a sense of justice. The Dog is a devoted friend and a defender of loved ones. The challenge: anxiety and pessimism.",
   "In love the Dog is one of the most faithful signs: sincere and devoted.",
   "At work the Dog does well in jobs connected with helping, law, protection and education."),
 "pig": ("Pig", "Generous, kind and cheerful; knows how to enjoy life.",
   "The Pig (or Boar) is generosity, kindness and joy in life. The Pig trusts people and knows how to enjoy things. The challenge: naivety and difficulty saying no.",
   "In love the Pig is generous, warm and romantic, and trusts easily.",
   "At work the Pig does well in food and hospitality, care, the arts and work with people: wherever kindness counts.")},
"moonSigns": [
 "Moon in Aries: emotions flare up fast and die down fast. You need action in order to feel well; idleness tires you more than effort. Anger comes easily, but you do not hold a grudge. Movement and being able to decide for yourself help you.",
 "Moon in Taurus: you need calm, comfort and predictability. You build security through tangible things: home, food, touch, a steady daily rhythm. Change takes you time. When you are in balance, you give others an enormous sense of stability.",
 "Moon in Gemini: you work through feelings by talking about them. You need stimulation, curiosity and someone to exchange thoughts with. Moods change quickly. Writing, conversation and lightness help you.",
 "Moon in Cancer: this is the Moon's natural home, with deep sensitivity and a need for closeness and home. You feel other people's moods strongly and remember old emotions. When something hurts, you retreat into your shell. A safe place and close people help you.",
 "Moon in Leo: you need to be seen and appreciated. You express emotions warmly and on a grand scale; a wounded heart quickly turns into pride. You give others a great deal of heart. Creativity, play and sincere recognition help you.",
 "Moon in Virgo: order and a sense of being needed give you peace. You often turn emotions into care for practical things and into analysis. You worry easily. Routine, working with your hands and gentleness towards your own mistakes help you.",
 "Moon in Libra: you need harmony and partnership. Conflict throws you off balance, so you give way easily to keep the peace. Beautiful surroundings matter to you. One-to-one conversation and naming your own needs help you.",
 "Moon in Scorpio: you feel intensely and deeply, but show little. You build trust slowly, and loyalty is everything to you. You find it hard to let go. Honesty, privacy and turning emotion into action help you.",
 "Moon in Sagittarius: you need freedom, space and meaning. Optimism helps you through hard moments, sometimes at the cost of actually living through them. You cope badly with restrictions. Travel, learning and a sense that life has a direction help you.",
 "Moon in Capricorn: you keep emotions under control and think of your duties first. A plan and a sense of being in command of the situation give you security. You rarely ask for help. Recognition of your effort and time just for yourself help you.",
 "Moon in Aquarius: you need independence and friendship more than displays of tenderness. You like to understand an emotion first and only then feel it. You are at ease in a group, but on your own terms. Space and people who accept that you are different help you.",
 "Moon in Pisces: a very empathetic Moon; you soak up the moods around you. You need quiet, art or spirituality to come back to yourself. You are easily moved, and quick to feel compassion. Boundaries, sleep and creativity help you."],
"ascSigns": [
 "Ascendant in Aries: at first glance, energy, directness and a fast pace. People see in you someone who acts before thinking. You go into new situations boldly. Take care that haste does not look like a lack of interest in others.",
 "Ascendant in Taurus: at first glance, calm, patience and a pleasant presence. You come across as stable and trustworthy. You get used to new situations slowly. Your strength is perseverance and good taste.",
 "Ascendant in Gemini: at first glance, curiosity, lively expressions and ease in conversation. You seem younger and more restless than you are. You make contact easily. Watch out for distraction.",
 "Ascendant in Cancer: at first glance, gentleness and caution. You sense the atmosphere first and only then open up. People feel warmth around you. Reserve towards strangers is often your protection.",
 "Ascendant in Leo: at first glance, self-confidence and warmth. You attract attention easily, even when you are not seeking it. There is something of the stage about you. Take care that pride does not hide your sensitivity.",
 "Ascendant in Virgo: at first glance, modesty, attentiveness and neatness. You come across as someone who knows what they are doing. You notice details that others miss. Watch out for judging yourself too harshly.",
 "Ascendant in Libra: at first glance, courtesy, charm and care for form. People feel at ease around you. You ease tensions naturally. Take care not to agree to everything for the sake of peace and quiet.",
 "Ascendant in Scorpio: at first glance, mystery and an intense gaze. You are hard to read, and you are comfortable with that. You have a strong presence. You give your trust gradually.",
 "Ascendant in Sagittarius: at first glance, openness, humour and enthusiasm. You seem like someone who is always looking for adventure. Your optimism spreads easily. Watch out for promises made in the heat of the moment.",
 "Ascendant in Capricorn: at first glance, seriousness, composure and maturity. People are quick to entrust you with responsibility. With age you often become lighter and more open. Take care not to carry everything alone.",
 "Ascendant in Aquarius: at first glance, originality and a slight distance. You stand out even if you do not plan to. You are friendly to everyone but close to few. Your strength is independent thinking.",
 "Ascendant in Pisces: at first glance, gentleness, dreaminess and sensitivity. People readily confide in you. You read moods well. You need boundaries so as not to take on other people's emotions."],
}

MONTHS = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
def dates(s):  # "21.03–19.04" -> "21 Mar – 19 Apr"
    a, b = s.split("–")
    f = lambda x: f"{int(x.split('.')[0])} {MONTHS[int(x.split('.')[1]) - 1]}"
    return f"{f(a)} – {f(b)}"

root = sys.argv[1]
pl = json.load(open(f"{root}/assets/content/astro.json", encoding="utf-8"), object_pairs_hook=collections.OrderedDict)
en = copy.deepcopy(pl)
for k in ["elements", "compat", "yearForecast", "chineseCompat", "haircut", "week", "eclipseText", "transits", "caution", "today"]:
    assert set(pl[k]) == set(T[k]), k
    for kk in pl[k]: en[k][kk] = T[k][kk]
    if k == "today": assert all(len(pl[k][x]) == len(T[k][x]) for x in pl[k])
en["mercury"] = T["mercury"]
assert len(T["phases"]) == len(pl["phases"])
en["phases"] = [{"name": n, "text": t} for n, t in T["phases"]]
for k, (n, t) in T["dayTypes"].items(): en["dayTypes"][k] = {"name": n, "text": t}
for k, (title, text, prompts) in T["rituals"].items(): en["rituals"][k] = {"title": title, "text": text, "prompts": prompts}
for k, (n, adj, t) in T["elements5"].items(): en["elements5"][k] = {"name": n, "adj": adj, "text": t}
assert set(en["dayTypes"]) == set(pl["dayTypes"]) and set(en["elements5"]) == set(pl["elements5"])
for s in en["signs"]:
    name, text, color, stone, day, planet, love, work, well = T["signs"][s["id"]]
    # English has no locative case: "Moon in Aries" uses the plain name.
    s.update(name=name, locative=name, dates=dates(s["dates"]), text=text, color=color, stone=stone, day=day, planet=planet, love=love, work=work, wellbeing=well)
for c in en["chinese"]:
    name, text, long, love, work = T["chinese"][c["id"]]
    c.update(name=name, text=text, long=long, love=love, work=work)
assert len(T["moonSigns"]) == 12 and len(T["ascSigns"]) == 12
en["moonSigns"], en["ascSigns"] = T["moonSigns"], T["ascSigns"]
open(f"{root}/assets/content/en/astro.json", "w", encoding="utf-8").write(json.dumps(en, ensure_ascii=False, indent=2) + "\n")
print("ok")
