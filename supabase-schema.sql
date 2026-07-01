-- 团队日程管理系统 Supabase 数据表

-- 1. 用户表
CREATE TABLE users (
  id BIGSERIAL PRIMARY KEY,
  name TEXT UNIQUE NOT NULL,
  password TEXT NOT NULL,
  role TEXT NOT NULL DEFAULT 'member' CHECK (role IN ('super', 'admin', 'member')),
  visible BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 2. 日程表
CREATE TABLE events (
  id BIGSERIAL PRIMARY KEY,
  title TEXT NOT NULL,
  date DATE NOT NULL,
  start_time TIME NOT NULL,
  end_time TIME NOT NULL,
  description TEXT DEFAULT '',
  images TEXT[] DEFAULT '{}',
  user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 3. 索引
CREATE INDEX idx_events_date ON events(date);
CREATE INDEX idx_events_user_id ON events(user_id);
CREATE INDEX idx_users_name ON users(name);

-- 4. 关闭 RLS（应用层自己处理认证）
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE events ENABLE ROW LEVEL SECURITY;

-- 5. 允许 anon key 完整读写（应用层控制权限）
CREATE POLICY "anon_select_users" ON users FOR SELECT TO anon USING (true);
CREATE POLICY "anon_insert_users" ON users FOR INSERT TO anon WITH CHECK (true);
CREATE POLICY "anon_update_users" ON users FOR UPDATE TO anon USING (true) WITH CHECK (true);
CREATE POLICY "anon_delete_users" ON users FOR DELETE TO anon USING (true);

CREATE POLICY "anon_select_events" ON events FOR SELECT TO anon USING (true);
CREATE POLICY "anon_insert_events" ON events FOR INSERT TO anon WITH CHECK (true);
CREATE POLICY "anon_update_events" ON events FOR UPDATE TO anon USING (true) WITH CHECK (true);
CREATE POLICY "anon_delete_events" ON events FOR DELETE TO anon USING (true);
