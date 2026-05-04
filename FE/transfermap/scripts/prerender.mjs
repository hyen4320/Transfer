import fs from 'node:fs'
import path from 'node:path'
import { fileURLToPath, pathToFileURL } from 'node:url'

const __dirname = path.dirname(fileURLToPath(import.meta.url))
const root = path.resolve(__dirname, '..')
const distClient = path.resolve(root, 'dist')
const distServer = path.resolve(root, 'dist/server')

const template = fs.readFileSync(path.join(distClient, 'index.html'), 'utf-8')

const serverEntry = path.join(distServer, 'entry-server.js')
const { render } = await import(pathToFileURL(serverEntry).href)

const routes = [
  '/',
  '/journalists',
  '/report',
  '/notice',
  '/info',
  '/search',
]

for (const route of routes) {
  try {
    const { html, helmet } = await render(route)

    const headTags = helmet
      ? [
          helmet.title?.toString() ?? '',
          helmet.meta?.toString() ?? '',
          helmet.link?.toString() ?? '',
        ].join('\n    ')
      : ''

    const page = template
      .replace('<!--app-head-->', headTags)
      .replace('<div id="root"><!--app-html--></div>', `<div id="root">${html}</div>`)

    const outDir = route === '/'
      ? distClient
      : path.join(distClient, route.slice(1))

    fs.mkdirSync(outDir, { recursive: true })
    fs.writeFileSync(path.join(outDir, 'index.html'), page)
    console.log(`Prerendered: ${route}`)
  } catch (e) {
    console.error(`Failed to prerender ${route}:`, e.message)
  }
}
