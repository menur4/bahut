package com.famille.calcul_moyenne

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.view.View
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider
import org.json.JSONArray

/**
 * Widget provider pour afficher les devoirs sur l'écran d'accueil.
 */
class HomeworkWidgetProvider : HomeWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.homework_widget_layout)

            // Récupérer les données JSON des devoirs
            val homeworkJson = widgetData.getString("homework_list", "[]") ?: "[]"

            try {
                val homeworkArray = JSONArray(homeworkJson)
                val count = homeworkArray.length()

                // Mettre à jour le badge de compteur
                views.setTextViewText(R.id.homework_count, count.toString())

                // Afficher/masquer l'état vide
                if (count == 0) {
                    views.setViewVisibility(R.id.empty_state, View.VISIBLE)
                } else {
                    views.setViewVisibility(R.id.empty_state, View.GONE)
                }

            } catch (e: Exception) {
                views.setTextViewText(R.id.homework_count, "0")
                views.setViewVisibility(R.id.empty_state, View.VISIBLE)
            }

            // Configurer le clic pour ouvrir l'app
            val intent = Intent(context, MainActivity::class.java)
            val pendingIntent = PendingIntent.getActivity(
                context,
                1,
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(android.R.id.background, pendingIntent)

            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
