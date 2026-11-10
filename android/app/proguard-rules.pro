# WorkManager (pulled in by Google Mobile Ads) creates its Room DB via reflection on the generated
# *_Impl class; R8 stripped it and the release build crashed at startup (seen on API 36 emulator).
-keep class * extends androidx.room.RoomDatabase { <init>(); }
-keep class androidx.work.impl.WorkDatabase_Impl { *; }
