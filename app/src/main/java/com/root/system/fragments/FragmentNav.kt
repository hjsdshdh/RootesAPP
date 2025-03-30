package com.root.system.fragments

import android.content.Intent
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import com.root.krscript.model.PageNode
import com.root.system.R
import com.projectkr.shell.OpenPageHelper // Ensure this is the correct import
import kotlinx.android.synthetic.main.fragment_nav.*
import android.widget.Toast
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import com.root.common.shell.KeepShellPublic
import com.root.kr.KrScriptConfig2
import com.root.system.activities.ActivityProcess
import com.root.system.dialogs.DiagRec
import kotlinx.android.synthetic.main.fragment_cpu_modes.*
import okhttp3.*
import java.io.IOException

class FragmentNav : Fragment(), View.OnClickListener {

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? = inflater.inflate(R.layout.fragment_nav, container, false)

    override fun onResume() {
        super.onResume()
        activity?.title = getString(R.string.app_name)
    }

private val client = OkHttpClient()

    
    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        val textView: TextView = view.findViewById(R.id.Service)
        val textView2: TextView = view.findViewById(R.id.Service2)


        fetchTextFromUrl("https://uapis.cn/api/say", textView2)

        fetchTextFromUrl("https://rootes.top/公告.txt", textView)
    
        nav_text.setOnClickListener {
            Toast.makeText(context, "🐮🍺", Toast.LENGTH_SHORT).show()
        }
        
        nav_otg.setOnClickListener {
            val pageNode = PageNode("").apply {
                title = "OTG功能"
                pageConfigSh = "/data/data/com.root.system/files/usr/pages/OTG.xml"
            }
            OpenPageHelper(requireActivity()).openPage(pageNode)
        }

        nav_magisk.setOnClickListener {
            val pageNode = PageNode("").apply {
                title = "Magisk功能"
                pageConfigPath = "/data/data/com.root.system/files/usr/pages/Magisk.xml"
            }
            OpenPageHelper(requireActivity()).openPage(pageNode)
        }

        nav_root.setOnClickListener {
            val pageNode = PageNode("").apply {
                title = "Root功能"
                pageConfigSh = "/data/data/com.root.system/files/usr/pages/Home/Root.xml"
            }
            OpenPageHelper(requireActivity()).openPage(pageNode)
        }

        nav_app.setOnClickListener {
            val pageNode = PageNode("").apply {
                title = "软件功能"
                pageConfigSh = "/data/data/com.root.system/files/usr/pages/Home/APP.xml"
            }
            OpenPageHelper(requireActivity()).openPage(pageNode)
        }

        nav_system.setOnClickListener {
            val pageNode = PageNode("").apply {
                title = "系统功能"
                pageConfigSh = "/data/data/com.root.system/files/usr/pages/Home/System.xml"
            }
            OpenPageHelper(requireActivity()).openPage(pageNode)
        }

        nav_battery.setOnClickListener {
            val pageNode = PageNode("").apply {
                title = "电池功能"
                pageConfigSh = "/data/data/com.root.system/files/usr/pages/Home/battery.xml"
            }
            OpenPageHelper(requireActivity()).openPage(pageNode)
        }

        nav_fq.setOnClickListener {
            val pageNode = PageNode("").apply {
                title = "分区功能"
                pageConfigSh = "/data/data/com.root.system/files/usr/pages/Home/fq.xml"
            }
            OpenPageHelper(requireActivity()).openPage(pageNode)
        }

        nav_bm.setOnClickListener {
            val pageNode = PageNode("").apply {
                title = "显示功能"
                pageConfigPath = "/data/data/com.root.system/files/usr/pages/Home/pm.xml"
            }
            OpenPageHelper(requireActivity()).openPage(pageNode)
        }

        nav_download.setOnClickListener {
            val pageNode = PageNode("").apply {
                title = "资源中心"
                pageConfigSh = "/data/data/com.root.system/files/usr/pages/Home/download.xml"
            }
            OpenPageHelper(requireActivity()).openPage(pageNode)
        }
        nav_text2.setOnClickListener {
            val pageNode = PageNode("").apply {
                title = "公告"
                pageConfigSh = "/data/data/com.root.system/files/usr/pages/Home/rootes.xml"
            }
            OpenPageHelper(requireActivity()).openPage(pageNode)
        }

        nav_data.setOnClickListener {
            val pageNode = PageNode("").apply {
                title = "文件功能"
                pageConfigPath = "/data/data/com.root.system/files/usr/pages/Home/files.xml"
            }
            OpenPageHelper(requireActivity()).openPage(pageNode)
        }

        nav_helpabout.setOnClickListener {
            val pageNode = PageNode("").apply {
                title = "搜索"
                pageConfigSh = "/data/data/com.root.system/files/usr/pages/Home/about.xml"
            }
            OpenPageHelper(requireActivity()).openPage(pageNode)
        }
    }
private fun fetchTextFromUrl(url: String, textView: TextView) {
        val request = Request.Builder()
            .url(url)
            .build()

        client.newCall(request).enqueue(object : Callback {
            override fun onFailure(call: Call, e: IOException) {
                // 在UI线程中处理错误
                activity?.runOnUiThread {
                    textView.text = "网络请求失败: ${e.message}"
                }
            }

            override fun onResponse(call: Call, response: Response) {
                response.use {
                    if (!response.isSuccessful) {
                        activity?.runOnUiThread {
                            textView.text = "网络请求失败: ${response.message}"
                        }
                    } else {
                        val responseData = response.body?.string()
                        activity?.runOnUiThread {
                            textView.text = responseData ?: "没有收到数据"
                        }
                    }
                }
            }
        })
    }
    override fun onClick(v: View?) {
        // Handle generic click events here if needed
    }
}
