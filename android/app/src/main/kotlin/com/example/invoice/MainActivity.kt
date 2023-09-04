package com.example.invoice
import android.annotation.SuppressLint
import android.graphics.*
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.graphics.Rect
import android.util.DisplayMetrics
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream
import android.graphics.Bitmap.CompressFormat
class MainActivity: FlutterActivity() {
    private val CHANNEL="samples.flutter.dev/battery"


    @SuppressLint("WrongThread")
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->
           if(call.method=="bitmap"){
               println("Here is funtion calling...")
               val displayMetrics = DisplayMetrics()
               windowManager.defaultDisplay.getMetrics(displayMetrics)
               val screenWidth = displayMetrics.widthPixels
               val image = textAsBitmap("sabitur", 40.0f,screenWidth)
               val byteArrayOutputStream = ByteArrayOutputStream()
               image.compress(CompressFormat.PNG,100,byteArrayOutputStream)
               println(byteArrayOutputStream.toByteArray())
               result.success(byteArrayOutputStream.toByteArray())
           }
        }
    }


    fun textAsBitmap(text: String, textSize: Float, maxWidth: Int): Bitmap {
        val paint = Paint(Paint.ANTI_ALIAS_FLAG)
        paint.textSize = textSize
        paint.color = Color.BLACK
        paint.textAlign = Paint.Align.LEFT

        val textBounds = Rect()
        paint.getTextBounds(text, 0, text.length, textBounds)

        val lineHeight = textBounds.height()

        val width = if (maxWidth > 0) {
            maxWidth
        } else {
            textBounds.width()
        }

        // Calculate the total height based on the wrapped content
        var totalHeight = 0
        var remainingText = text
        while (remainingText.isNotEmpty()) {
            val breakIndex = calculateLineBreakIndex(paint, remainingText, width)
            totalHeight += lineHeight
            remainingText = remainingText.substring(breakIndex).trimStart()
        }

        // Create the bitmap with the calculated total height
        val image = Bitmap.createBitmap(width, totalHeight, Bitmap.Config.ARGB_8888)
        val canvas = Canvas(image)

        var y = -paint.ascent() // Start drawing from the baseline

        remainingText = text
        while (remainingText.isNotEmpty()) {
            val breakIndex = calculateLineBreakIndex(paint, remainingText, width)
            val line = remainingText.substring(0, breakIndex)
            canvas.drawText(line, 0f, y, paint)
            y += lineHeight
            remainingText = remainingText.substring(breakIndex).trimStart()
        }

        return image
    }


    fun calculateLineBreakIndex(paint: Paint, text: String, maxWidth: Int): Int {
        var endIndex = text.length
        var measuredWidth: Float

        // Initialize a placeholder value for the break index
        var breakIndex = endIndex

        // Start from the end of the text and work backward
        while (endIndex > 0) {
            measuredWidth = paint.measureText(text.substring(0, endIndex))
            if (measuredWidth <= maxWidth) {
                // Found a valid break point
                breakIndex = endIndex
                break
            }
            endIndex--
        }

        return breakIndex
    }
}
