package com.famille.calcul_moyenne

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.view.View
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider
import org.json.JSONObject
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

/**
 * Widget provider pour afficher l'emploi du temps sur l'écran d'accueil.
 */
class ScheduleWidgetProvider : HomeWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.schedule_widget_layout)

            // Afficher la date du jour
            val dateFormat = SimpleDateFormat("EEE d MMM", Locale.FRANCE)
            views.setTextViewText(R.id.current_date, dateFormat.format(Date()))

            // Récupérer les données du prochain cours
            val nextCourseJson = widgetData.getString("next_course", null)

            try {
                if (nextCourseJson != null) {
                    val nextCourse = JSONObject(nextCourseJson)

                    views.setViewVisibility(R.id.next_course_container, View.VISIBLE)
                    views.setTextViewText(R.id.next_course_subject, nextCourse.getString("subject"))

                    val startTime = nextCourse.getString("startTime")
                    val endTime = nextCourse.getString("endTime")
                    views.setTextViewText(R.id.next_course_time, "$startTime - $endTime")

                    val room = nextCourse.optString("room", "")
                    views.setTextViewText(R.id.next_course_room, if (room.isNotEmpty()) "Salle $room" else "")

                    views.setViewVisibility(R.id.empty_state, View.GONE)
                } else {
                    views.setViewVisibility(R.id.next_course_container, View.GONE)
                    views.setViewVisibility(R.id.empty_state, View.VISIBLE)
                }
            } catch (e: Exception) {
                views.setViewVisibility(R.id.next_course_container, View.GONE)
                views.setViewVisibility(R.id.empty_state, View.VISIBLE)
            }

            // Configurer le clic pour ouvrir l'app
            val intent = Intent(context, MainActivity::class.java)
            val pendingIntent = PendingIntent.getActivity(
                context,
                2,
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(android.R.id.background, pendingIntent)

            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
