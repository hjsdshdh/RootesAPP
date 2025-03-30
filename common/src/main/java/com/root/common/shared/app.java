package com.root.common.shared;

import android.content.Context;

import java.io.IOException;
import java.io.InputStream;

public class app {
        public static String read(Context context, String fileName) {
            StringBuilder stringBuilder = new StringBuilder();
            try {
                InputStream inputStream = context.getAssets().open(fileName);
                int character;
                while ((character = inputStream.read()) != -1) {
                    stringBuilder.append((char) character);
                }
                inputStream.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
            return stringBuilder.toString();
        }
    }
