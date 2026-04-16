import { Component, type ReactNode } from 'react';
import ErrorPage from './ErrorPage';

interface Props  { children: ReactNode; }
interface State  { hasError: boolean; }

export default class ErrorBoundary extends Component<Props, State> {
  state: State = { hasError: false };

  static getDerivedStateFromError(): State {
    return { hasError: true };
  }

  render() {
    if (this.state.hasError) {
      return <ErrorPage code={500} />;
    }
    return this.props.children;
  }
}
