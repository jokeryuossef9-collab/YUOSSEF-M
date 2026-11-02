-- شغّل الملف ده في Supabase: SQL Editor ← New query ← Run

-- 1) الجداول
create table if not exists projects (
  id bigint generated always as identity primary key,
  title text not null,
  category text default 'social',
  cover_image text,
  gallery text[] default '{}',
  is_new boolean default false,
  published boolean default true,
  sort_order int default 0
);

create table if not exists packages (
  id bigint generated always as identity primary key,
  title text not null,
  price text,
  old_price text,
  discount_label text,
  features text[] default '{}',
  published boolean default true,
  sort_order int default 0
);

create table if not exists courses (
  id bigint generated always as identity primary key,
  title text not null,
  description text,
  image text,
  price text,
  old_price text,
  discount_label text,
  features text[] default '{}',
  modules jsonb default '[]',
  published boolean default true,
  sort_order int default 0
);

create table if not exists testimonials (
  id bigint generated always as identity primary key,
  name text not null,
  role text,
  body text,
  published boolean default true,
  sort_order int default 0
);

create table if not exists site_settings (
  key text primary key,
  value text
);

-- 2) الصلاحيات: الزوار يقرأوا بس، والأدمن المسجّل دخول يعدّل
alter table projects enable row level security;
alter table packages enable row level security;
alter table courses enable row level security;
alter table testimonials enable row level security;
alter table site_settings enable row level security;

create policy "public read" on projects for select using (true);
create policy "admin write" on projects for all to authenticated using (true) with check (true);
create policy "public read" on packages for select using (true);
create policy "admin write" on packages for all to authenticated using (true) with check (true);
create policy "public read" on courses for select using (true);
create policy "admin write" on courses for all to authenticated using (true) with check (true);
create policy "public read" on testimonials for select using (true);
create policy "admin write" on testimonials for all to authenticated using (true) with check (true);
create policy "public read" on site_settings for select using (true);
create policy "admin write" on site_settings for all to authenticated using (true) with check (true);

-- 3) البيانات الحالية في الموقع (نقلها للقاعدة)
insert into projects (title, category, cover_image, gallery, is_new, sort_order) values
('حملة سوشيال ميديا - طلبات', 'social', 'https://i.postimg.cc/3rz0ZPQP/FB-IMG-1793405873803.jpg', array['https://i.postimg.cc/ht1JcvQP/FB-IMG-1793405878950.jpg','https://i.postimg.cc/x13kn8N1/FB-IMG-1793405882435.jpg','https://i.postimg.cc/XYkZ4qBJ/FB-IMG-1793405884683.jpg','https://i.postimg.cc/RZL34hJC/FB-IMG-1793405886957.jpg'], true, 1),
('حملة سوشيال ميديا - الفريق خميس', 'social', 'https://i.postimg.cc/1502H1Nz/FB-IMG-1793404892228.jpg', array['https://i.postimg.cc/xd8Znkpv/FB-IMG-1793404899899.jpg','https://i.postimg.cc/jj21tW3S/FB-IMG-1793404903545.jpg','https://i.postimg.cc/hGvYcJZQ/FB-IMG-1793404909274.jpg','https://i.postimg.cc/wBrGv6nJ/FB-IMG-1793404984329.jpg'], false, 2),
('حملة سوشيال ميديا - مشروع جديد', 'social', 'https://i.postimg.cc/xd0DLF4c/FB-IMG-1793399730053.jpg', array['https://i.postimg.cc/MXkgHsBy/FB-IMG-1793399734239.jpg','https://i.postimg.cc/44KdKmcS/FB-IMG-1793399737652.jpg','https://i.postimg.cc/HjGFnSM3/FB-IMG-1793399747014.jpg','https://i.postimg.cc/LhdG5yPD/FB-IMG-1793399750224.jpg'], false, 3),
('حملة سوشيال ميديا - مشروع مميز', 'social', 'https://i.postimg.cc/hP7Cvbpq/FB-IMG-1793399051535.jpg', array['https://i.postimg.cc/gJTDknhd/FB-IMG-1793399059640.jpg','https://i.postimg.cc/W3HnbhZ3/FB-IMG-1793399063223.jpg','https://i.postimg.cc/wvGVT7NT/FB-IMG-1793399069307.jpg','https://i.postimg.cc/0QBf2bSq/FB-IMG-1793399073362.jpg'], false, 4),
('حملة سوشيال ميديا - OREO', 'social', 'https://i.postimg.cc/yx0Z4dXM/FB-IMG-1793398218764.jpg', array['https://i.postimg.cc/3xtDHzpP/FB-IMG-1793398223707.jpg','https://i.postimg.cc/zGzR6qbz/FB-IMG-1793398226964.jpg','https://i.postimg.cc/Bnm1GRH9/FB-IMG-1793398230828.jpg','https://i.postimg.cc/6pWGgB26/FB-IMG-1793398234474.jpg'], false, 5),
('حملة سوشيال ميديا - WE SONIC', 'social', 'https://i.postimg.cc/BnVRkQhR/FB-IMG-1793397469863.jpg', array['https://i.postimg.cc/pTD7mQ2d/FB-IMG-1793397476305.jpg','https://i.postimg.cc/wvhP156j/FB-IMG-1793397480710.jpg','https://i.postimg.cc/rmSbDG8m/FB-IMG-1793397485155.jpg','https://i.postimg.cc/qR8YNckq/FB-IMG-1793397488672.jpg'], false, 6),
('حملة سوشيال ميديا - Tabby', 'social', 'https://i.postimg.cc/GmVv6Zv7/FB-IMG-1793397047122.jpg', array['https://i.postimg.cc/6pv84TGj/FB-IMG-1793397051863.jpg','https://i.postimg.cc/rwrDRztf/FB-IMG-1793397056179.jpg','https://i.postimg.cc/kgb2RDtj/FB-IMG-1793397058833.jpg','https://i.postimg.cc/rwrDRztg/FB-IMG-1793397061941.jpg'], false, 7),
('حملة KOSMOLITA CLINIC', 'identity', 'https://i.postimg.cc/k5bLdv84/IMG-20261029-WA0264.jpg', array['https://i.postimg.cc/1t0T8Rv4/FB-IMG-1793395553117.jpg','https://i.postimg.cc/d1RXhQ5V/FB-IMG-1793395556773.jpg','https://i.postimg.cc/SsL5nQgR/FB-IMG-1793395560665.jpg','https://i.postimg.cc/pTQ7mVsd/FB-IMG-1793395657468.jpg'], false, 8),
('حملة سوشيال ميديا - دجاج مقرمش', 'social', 'https://i.postimg.cc/ZqMhxqmq/485893870-1793390740785796.jpg', array['https://i.postimg.cc/FKBQVKvs/176635013-1793390744359588.jpg','https://i.postimg.cc/YSswzS74/479785028-1793390743585459.jpg','https://i.postimg.cc/mD1WXGZk/697932327-1793390742700277.jpg','https://i.postimg.cc/fbrhfbsz/995122413-1793390741768358.jpg'], false, 9);

insert into packages (title, price, old_price, discount_label, features, sort_order) values
('باقة السوشيال ميديا', '1500', '2000', 'خصم 25%', array['10 تصميمات سوشيال ميديا عالية الجودة','تصميمات HD وجاهزة للنشر','تسليم سريع خلال 3 أيام عمل','تعديلات مجانية حتى الرضا التام'], 1),
('باقة التصميمين', '250', null, null, array['تصميمين سوشيال ميديا','تسليم خلال 24 ساعة','جودة عالية ومناسبة للاستخدام'], 2);

insert into courses (title, description, image, price, old_price, discount_label, features, modules, sort_order) values
('دبلومة الذكاء الاصطناعي', 'ابدأ رحلتك في عالم الذكاء الاصطناعي وتعلم أحدث الأدوات من الصفر للاحتراف.', 'https://i.postimg.cc/4yYLRjWW/644684898-1793407016330626.jpg', '750', '1500', 'خصم 50%', array['فيديوهات مسجلة بجودة عالية','شهادة معتمدة بعد التخرج','متابعة ودعم فني مستمر'],
'[{"title":"الوحدة الأولى: مقدمة في الذكاء الاصطناعي","lessons":["ما هو الذكاء الاصطناعي؟","تطبيقاته في سوق العمل."]},{"title":"الوحدة الثانية: هندسة الأوامر (Prompt Engineering)","lessons":["أساسيات كتابة الأوامر.","أدوات متقدمة لتوليد الصور والنصوص."]},{"title":"الوحدة الثالثة: مشاريع عملية","lessons":["بناء شات بوت بسيط.","استخدام الذكاء الاصطناعي في التصميم."]}]', 1);

insert into testimonials (name, role, body, sort_order) values
('أحمد محمود', 'صاحب مطعم', 'شغل احترافي جداً، يوسف فهم فكرة البراند بتاعنا من أول مرة وطلع الهوية أحلى من اللي كنا متخيلينه.', 1),
('منة الله سامي', 'مديرة تسويق', 'التزام في المواعيد، وأفكار إبداعية في تصميمات السوشيال ميديا. بنشتغل معاه من سنتين ومستمرين.', 2);

insert into site_settings (key, value) values
('whatsapp', '201154012821'),
('phone', '201154012821'),
('email', 'info@yuossef.com'),
('facebook', 'https://www.facebook.com/share/1EqptCPXaj/');
