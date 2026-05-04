import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import tailwindcss from '@tailwindcss/vite'

export default defineConfig(({ mode }) => {
  const isSSR = mode === 'ssr'
  return {
    plugins: [react(), tailwindcss()],
    server: {
      proxy: {
        '/api': 'http://localhost:8080',
      },
    },
    build: {
      outDir: isSSR ? 'dist/server' : 'dist',
      ssr: isSSR ? 'src/entry-server.tsx' : undefined,
    },
    ...(isSSR && {
      ssr: {
        noExternal: ['react-helmet-async'],
      },
    }),
  }
})
