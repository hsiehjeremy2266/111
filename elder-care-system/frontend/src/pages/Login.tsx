import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { ShieldCheck } from 'lucide-react';
import api from '../services/api';

export default function Login() {
    const [username, setUsername] = useState('');
    const [password, setPassword] = useState('');
    const [error, setError] = useState('');
    const navigate = useNavigate();

    const handleLogin = async (e: React.FormEvent) => {
        e.preventDefault();
        try {
            const formData = new URLSearchParams();
            formData.append('username', username);
            formData.append('password', password);

            const response = await api.post('/auth/login', formData, {
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
            });

            localStorage.setItem('token', response.data.access_token);
            navigate('/');
        } catch (err) {
            setError('Invalid username or password');
        }
    };

    return (
        <div className="flex min-h-screen items-center justify-center bg-zinc-950 px-4">
            <div className="w-full max-w-md space-y-8 rounded-2xl bg-zinc-900 p-8 pt-10 shadow-2xl ring-1 ring-white/10">
                <div className="text-center">
                    <div className="mx-auto flex h-16 w-16 items-center justify-center rounded-full bg-indigo-500/10 text-indigo-500">
                        <ShieldCheck size={32} />
                    </div>
                    <h2 className="mt-6 text-3xl font-bold tracking-tight text-white">Caregiver Access</h2>
                    <p className="mt-2 text-sm text-zinc-400">Sign in to monitor elders</p>
                </div>

                <form className="mt-8 space-y-6" onSubmit={handleLogin}>
                    {error && (
                        <div className="rounded-lg bg-red-500/10 p-4 text-sm text-red-400 border border-red-500/20">
                            {error}
                        </div>
                    )}

                    <div className="space-y-4 rounded-md shadow-sm">
                        <div>
                            <label className="block text-sm font-medium text-zinc-300 mb-1">Username</label>
                            <input
                                type="text"
                                required
                                value={username}
                                onChange={(e) => setUsername(e.target.value)}
                                className="block w-full rounded-lg border-0 bg-zinc-800/50 py-2.5 px-4 text-white ring-1 ring-inset ring-zinc-700/50 focus:ring-2 focus:ring-inset focus:ring-indigo-500 sm:text-sm sm:leading-6 placeholder:text-zinc-500"
                                placeholder="caregiver_01"
                            />
                        </div>
                        <div>
                            <label className="block text-sm font-medium text-zinc-300 mb-1">Password</label>
                            <input
                                type="password"
                                required
                                value={password}
                                onChange={(e) => setPassword(e.target.value)}
                                className="block w-full rounded-lg border-0 bg-zinc-800/50 py-2.5 px-4 text-white ring-1 ring-inset ring-zinc-700/50 focus:ring-2 focus:ring-inset focus:ring-indigo-500 sm:text-sm sm:leading-6 placeholder:text-zinc-500"
                                placeholder="••••••••"
                            />
                        </div>
                    </div>

                    <button
                        type="submit"
                        className="flex w-full justify-center rounded-lg bg-indigo-600 px-3 py-3 text-sm font-semibold text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600 transition-colors"
                    >
                        Sign in
                    </button>
                </form>
            </div>
        </div>
    );
}
