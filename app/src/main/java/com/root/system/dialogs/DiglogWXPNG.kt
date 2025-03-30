package com.root.system.dialogs

import android.app.Activity
import android.content.Intent
import android.net.Uri
import com.root.common.shell.KeepShellPublic
import com.root.common.ui.DialogHelper
import android.widget.ImageView
import android.widget.Toast
import com.root.system.R

class DialogWXPNG(var context: Activity) {
    fun showWXPNGMenu() {
        val view = context.layoutInflater.inflate(R.layout.dialog_wxpng_operation, null)
        val dialog = DialogHelper.customDialog(context, view)

        // Function to execute power operation
        fun executePowerOperation(cmd: String) {
            dialog.dismiss()
            KeepShellPublic.doCmdSync(cmd)
        }

        // Adding support for wxpng image
        val imageView = view.findViewById<ImageView>(R.id.imageView)
        imageView.setImageResource(R.drawable.wxpng)
        imageView.setOnClickListener {
            // Implement image click functionality here
            // For example, you can open an image viewer to display the wxpng image
            val intent = Intent(Intent.ACTION_VIEW)
            intent.setDataAndType(Uri.parse("android.resource://${context.packageName}/${R.drawable.wxpng}"), "image/*")
            context.startActivity(intent)
            Toast.makeText(context, "谢谢", Toast.LENGTH_LONG).show()
        }
    }
}
