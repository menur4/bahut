package com.famille.calcul_moyenne

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider

/**
 * Widget provider pour afficher la moyenne générale sur l'écran d'accueil.
 */
class AverageWidgetProvider : HomeWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.average_widget_layout)

            // Récupérer les données
            val average = widgetData.getString("general_average", "--") ?: "--"
            val childName = widgetData.getString("child_name", "") ?: ""
            val gradeCount = widgetData.getInt("grade_count", 0)

            // Mettre à jour les vues
            views.setTextViewText(R.id.average_value, average)
            views.setTextViewText(R.id.child_name, childName)
            views.setTextViewText(R.id.grade_count, if (gradeCount > 0) "$gradeCount notes" else "")

            // Configurer le clic pour ouvrir l'app
            val intent = Intent(context, MainActivity::class.java)
            val pendingIntent = PendingIntent.getActivity(
                context,
                0,
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.average_value, pendingIntent)

            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
