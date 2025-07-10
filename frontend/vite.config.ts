import path from "path";
import { defineConfig, loadEnv } from "vite";
import checker from "vite-plugin-checker";
import react from "@vitejs/plugin-react";
import { createHtmlPlugin } from "vite-plugin-html";

// https://vitejs.dev/config/
export default ({ mode }) => {
  const env = loadEnv(mode, process.cwd());
  process.env = { ...process.env, ...env };
  
  // Environment-aware backend URL detection
  const getBackendUrl = () => {
    // Check if we have explicit backend URL from environment
    if (env.VITE_HTTP_BACKEND_URL) {
      return env.VITE_HTTP_BACKEND_URL;
    }
    
    // Check if we're in Codespaces
    if (process.env.CODESPACE_NAME) {
      return `https://${process.env.CODESPACE_NAME}-7001.app.github.dev`;
    }
    
    // Default to localhost for local development
    return 'http://localhost:7001';
  };

  const backendUrl = getBackendUrl();
  
  return defineConfig({
    base: "",
    plugins: [
      react(),
      checker({ 
        typescript: true
      }),
      createHtmlPlugin({
        inject: {
          data: {
            injectHead: process.env.VITE_IS_DEPLOYED
              ? '<script defer="" data-domain="screenshottocode.com" src="https://plausible.io/js/script.js"></script>'
              : "",
          },
        },
      }),
    ],
    server: {
      proxy: {
        '/api': {
          target: backendUrl,
          changeOrigin: true,
          rewrite: (path) => path.replace(/^\/api/, ''),
          ws: true, // Enable WebSocket proxying
        }
      }
    },
    resolve: {
      alias: {
        "@": path.resolve(__dirname, "./src"),
      },
    },
  });
};
