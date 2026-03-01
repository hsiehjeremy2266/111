import { Outlet, Navigate, useNavigate, NavLink } from 'react-router-dom';
import { ShieldCheck, Video, Users, Activity, LogOut, Settings } from 'lucide-react';

export default function Layout() {
    const navigate = useNavigate();
    const token = localStorage.getItem('token');

    if (!token) {
        return <Navigate to="/login" replace />;
    }

    const handleLogout = () => {
        localStorage.removeItem('token');
        navigate('/login');
    };

    const navItem = (to: string, Icon: any, label: string) => (
        <NavLink to={to} end={to === '/'}
            className={({ isActive }) =>
                `flex items-center px-3 py-2.5 rounded-lg transition-colors ${isActive
                    ? 'bg-indigo-500/10 text-indigo-400 font-medium'
                    : 'text-zinc-400 hover:bg-zinc-800/50 hover:text-white'
                }`
            }
        >
            <Icon className="mr-3 flex-shrink-0" size={20} />
            {label}
        </NavLink>
    );

    return (
        <div className="flex h-screen overflow-hidden bg-zinc-950 text-white">
            {/* 側邊欄 */}
            <aside className="w-64 flex-shrink-0 border-r border-zinc-800 bg-zinc-900/50 flex flex-col">
                <div className="flex h-16 items-center px-6 border-b border-zinc-800 bg-zinc-950 gap-3">
                    <ShieldCheck className="text-indigo-500 flex-shrink-0" size={24} />
                    <span className="text-base font-bold tracking-tight leading-tight">長照視覺監控系統</span>
                </div>

                <nav className="flex-1 overflow-y-auto py-4 px-3 space-y-1">
                    {navItem('/', Video, '即時監控')}
                    {navItem('/elders', Users, '長者管理')}
                    {navItem('/logs', Activity, '異常記錄')}
                    {navItem('/settings', Settings, '系統設定')}
                </nav>

                <div className="p-4 border-t border-zinc-800 bg-zinc-950">
                    <button
                        onClick={handleLogout}
                        className="flex w-full items-center px-3 py-2.5 rounded-lg text-zinc-400 hover:bg-red-500/10 hover:text-red-400 transition-colors"
                    >
                        <LogOut className="mr-3 flex-shrink-0" size={20} />
                        登出
                    </button>
                </div>
            </aside>

            {/* 主內容 */}
            <main className="flex-1 overflow-y-auto">
                <Outlet />
            </main>
        </div>
    );
}
