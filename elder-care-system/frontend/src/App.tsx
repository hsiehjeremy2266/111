import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import Layout from './components/Layout';
import Login from './pages/Login';
import Dashboard from './pages/Dashboard';
import EldersPage from './pages/Elders';
import LogsPage from './pages/Logs';

function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/login" element={<Login />} />

        <Route element={<Layout />}>
          <Route path="/" element={<Dashboard />} />
          <Route path="/elders" element={<EldersPage />} />
          <Route path="/logs" element={<LogsPage />} />
          <Route path="/settings" element={<div className="p-8 text-zinc-400">系統設定（即將推出）</div>} />
        </Route>

        <Route path="*" element={<Navigate to="/" replace />} />
      </Routes>
    </BrowserRouter>
  );
}

export default App;
