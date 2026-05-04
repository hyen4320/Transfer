import { renderToString } from 'react-dom/server'
import { MemoryRouter } from 'react-router-dom'
import { HelmetProvider } from 'react-helmet-async'
import App from './App'

export async function render(url: string) {
  const helmetContext: Record<string, unknown> = {}
  const html = renderToString(
    <HelmetProvider context={helmetContext}>
      <MemoryRouter initialEntries={[url]}>
        <App />
      </MemoryRouter>
    </HelmetProvider>
  )
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  const { helmet } = helmetContext as { helmet: any }
  return { html, helmet }
}
