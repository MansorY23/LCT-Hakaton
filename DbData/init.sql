
GRANT ALL PRIVILEGES ON DATABASE database_name TO username;
CREATE SCHEMA IF NOT EXISTS public;



CREATE TABLE IF NOT EXISTS django_session (
	session_key varchar(40) NOT NULL,
	session_data text NOT NULL,
	expire_date timestamptz NOT NULL,
	CONSTRAINT django_session_pkey PRIMARY KEY (session_key)
);

CREATE TABLE IF NOT EXISTS "TaskType" (
	uuid uuid NOT NULL,
	"name" varchar(128) NOT NULL,
	priority int2 NOT NULL,
	work_time int2 NOT NULL,
	condition_1 varchar(256) NOT NULL,
	condition_2 varchar(256) NOT NULL,
	grade int2 NOT NULL,
	CONSTRAINT "TaskType_grade_check" CHECK ((grade >= 0)),
	CONSTRAINT "TaskType_pkey" PRIMARY KEY (uuid),
	CONSTRAINT "TaskType_priority_check" CHECK ((priority >= 0)),
	CONSTRAINT "TaskType_work_time_check" CHECK ((work_time >= 0))
);


CREATE TABLE IF NOT EXISTS django_migrations (
	id int8 NOT NULL GENERATED BY DEFAULT AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1 NO CYCLE),
	app varchar(255) NOT NULL,
	"name" varchar(255) NOT NULL,
	applied timestamptz NOT NULL,
	CONSTRAINT django_migrations_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS "AgentPoint" (
	uuid uuid NOT NULL,
	address varchar(255) NOT NULL,
	agent_point_date varchar(25) NOT NULL,
	materials bool NOT NULL,
	last_card_given date NULL,
	num_given_cards int2 NOT NULL,
	approved_requests int2 NOT NULL,
	last_deliver date,
	last_teaching date,
	last_stimulation date,
	CONSTRAINT "AgentPoint_pkey" PRIMARY KEY (uuid)
);


CREATE TABLE IF NOT EXISTS auth_group (
	id int4 NOT NULL GENERATED BY DEFAULT AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE),
	"name" varchar(150) NOT NULL,
	CONSTRAINT auth_group_name_key UNIQUE (name),
	CONSTRAINT auth_group_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS accounts_user (
	"password" varchar(128) NOT NULL,
	last_login timestamptz NULL,
	is_superuser bool NOT NULL,
	username varchar(150) NOT NULL,
	first_name varchar(150) NOT NULL,
	last_name varchar(150) NOT NULL,
	is_staff bool NOT NULL,
	is_active bool NOT NULL,
	date_joined timestamptz NOT NULL,
	uuid uuid NOT NULL,
	"role" int2 NOT NULL,
	phone_number varchar(32) NOT NULL,
	middle_name varchar(100) NOT NULL,
	email varchar(255) NOT NULL,
	grade int2 NOT NULL,
	address varchar(255) NOT NULL,
	CONSTRAINT accounts_user_email_key UNIQUE (email),
	CONSTRAINT accounts_user_grade_check CHECK ((grade >= 0)),
	CONSTRAINT accounts_user_pkey PRIMARY KEY (uuid),
	CONSTRAINT accounts_user_username_key UNIQUE (username)
);
CREATE TABLE IF NOT EXISTS django_content_type (
	id int4 NOT NULL GENERATED BY DEFAULT AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE),
	app_label varchar(100) NOT NULL,
	model varchar(100) NOT NULL,
	CONSTRAINT django_content_type_app_label_model_76bd3d3b_uniq UNIQUE (app_label, model),
	CONSTRAINT django_content_type_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS auth_permission (
	id int4 NOT NULL GENERATED BY DEFAULT AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE),
	"name" varchar(255) NOT NULL,
	content_type_id int4 NOT NULL,
	codename varchar(100) NOT NULL,
	CONSTRAINT auth_permission_content_type_id_codename_01ab375a_uniq UNIQUE (content_type_id, codename),
	CONSTRAINT auth_permission_pkey PRIMARY KEY (id),
	CONSTRAINT auth_permission_content_type_id_2f476e4b_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED
);


CREATE TABLE IF NOT EXISTS accounts_user_user_permissions (
	id int8 NOT NULL GENERATED BY DEFAULT AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1 NO CYCLE),
	user_id uuid NOT NULL,
	permission_id int4 NOT NULL,
	CONSTRAINT accounts_user_user_permi_user_id_permission_id_2ab516c2_uniq UNIQUE (user_id, permission_id),
	CONSTRAINT accounts_user_user_permissions_pkey PRIMARY KEY (id),
	CONSTRAINT accounts_user_user_p_permission_id_113bb443_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED,
	CONSTRAINT accounts_user_user_p_user_id_e4f0a161_fk_accounts_ FOREIGN KEY (user_id) REFERENCES public.accounts_user(uuid) DEFERRABLE INITIALLY DEFERRED
);




CREATE TABLE IF NOT EXISTS django_admin_log (
	id int4 NOT NULL GENERATED BY DEFAULT AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE),
	action_time timestamptz NOT NULL,
	object_id text NULL,
	object_repr varchar(200) NOT NULL,
	action_flag int2 NOT NULL,
	change_message text NOT NULL,
	content_type_id int4 NULL,
	user_id uuid NOT NULL,
	CONSTRAINT django_admin_log_action_flag_check CHECK ((action_flag >= 0)),
	CONSTRAINT django_admin_log_pkey PRIMARY KEY (id),
	CONSTRAINT django_admin_log_content_type_id_c4bce8eb_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED,
	CONSTRAINT django_admin_log_user_id_c564eba6_fk_accounts_user_uuid FOREIGN KEY (user_id) REFERENCES public.accounts_user(uuid) DEFERRABLE INITIALLY DEFERRED
);



CREATE TABLE IF NOT EXISTS authtoken_token (
	"key" varchar(40) NOT NULL,
	created timestamptz NOT NULL,
	user_id uuid NOT NULL,
	CONSTRAINT authtoken_token_pkey PRIMARY KEY (key),
	CONSTRAINT authtoken_token_user_id_key UNIQUE (user_id),
	CONSTRAINT authtoken_token_user_id_35299eff_fk_accounts_user_uuid FOREIGN KEY (user_id) REFERENCES public.accounts_user(uuid) DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE IF NOT EXISTS "Task" (
	uuid uuid NOT NULL,
	appointment_date date NULL,
	priority int2 NOT NULL,
	status int2 NOT NULL,
	task_type int2 NOT NULL,
	"comment" text NULL,
	favorite bool NOT NULL,
	employee_id uuid NULL,
	CONSTRAINT "Task_pkey" PRIMARY KEY (uuid),
	CONSTRAINT "Task_priority_check" CHECK ((priority >= 0)),
	CONSTRAINT "Task_status_check" CHECK ((status >= 0)),
	CONSTRAINT "Task_task_type_check" CHECK ((task_type >= 0)),
	CONSTRAINT "Task_employee_id_493e2cab_fk_accounts_user_uuid" FOREIGN KEY (employee_id) REFERENCES public.accounts_user(uuid) DEFERRABLE INITIALLY DEFERRED
);




CREATE TABLE IF NOT EXISTS accounts_user_groups (
	id int8 NOT NULL GENERATED BY DEFAULT AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1 NO CYCLE),
	user_id uuid NOT NULL,
	group_id int4 NOT NULL,
	CONSTRAINT accounts_user_groups_pkey PRIMARY KEY (id),
	CONSTRAINT accounts_user_groups_user_id_group_id_59c0b32f_uniq UNIQUE (user_id, group_id),
	CONSTRAINT accounts_user_groups_group_id_bd11a704_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED,
	CONSTRAINT accounts_user_groups_user_id_52b62117_fk_accounts_user_uuid FOREIGN KEY (user_id) REFERENCES public.accounts_user(uuid) DEFERRABLE INITIALLY DEFERRED
);


CREATE TABLE IF NOT EXISTS auth_group_permissions (
	id int8 NOT NULL GENERATED BY DEFAULT AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1 NO CYCLE),
	group_id int4 NOT NULL,
	permission_id int4 NOT NULL,
	CONSTRAINT auth_group_permissions_group_id_permission_id_0cd325b0_uniq UNIQUE (group_id, permission_id),
	CONSTRAINT auth_group_permissions_pkey PRIMARY KEY (id),
	CONSTRAINT auth_group_permissio_permission_id_84c5c92e_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED,
	CONSTRAINT auth_group_permissions_group_id_b120cbf9_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED
);


CREATE INDEX accounts_user_email_b2644a56_like ON public.accounts_user USING btree (email varchar_pattern_ops);
CREATE INDEX accounts_user_username_6088629e_like ON public.accounts_user USING btree (username varchar_pattern_ops);
CREATE INDEX auth_group_permissions_group_id_b120cbf9 ON public.auth_group_permissions USING btree (group_id);
CREATE INDEX auth_group_permissions_permission_id_84c5c92e ON public.auth_group_permissions USING btree (permission_id);
CREATE INDEX accounts_user_groups_group_id_bd11a704 ON public.accounts_user_groups USING btree (group_id);
CREATE INDEX accounts_user_groups_user_id_52b62117 ON public.accounts_user_groups USING btree (user_id);
CREATE INDEX django_session_expire_date_a5c62663 ON public.django_session USING btree (expire_date);
CREATE INDEX django_session_session_key_c0390e0f_like ON public.django_session USING btree (session_key varchar_pattern_ops);
CREATE INDEX accounts_user_user_permissions_permission_id_113bb443 ON public.accounts_user_user_permissions USING btree (permission_id);
CREATE INDEX accounts_user_user_permissions_user_id_e4f0a161 ON public.accounts_user_user_permissions USING btree (user_id);
CREATE INDEX authtoken_token_key_10f0b77e_like ON public.authtoken_token USING btree (key varchar_pattern_ops);
CREATE INDEX "Task_employee_id_493e2cab" ON public."Task" USING btree (employee_id);
CREATE INDEX auth_permission_content_type_id_2f476e4b ON public.auth_permission USING btree (content_type_id);
CREATE INDEX django_admin_log_content_type_id_c4bce8eb ON public.django_admin_log USING btree (content_type_id);
CREATE INDEX django_admin_log_user_id_c564eba6 ON public.django_admin_log USING btree (user_id);
CREATE INDEX auth_group_name_a6ea08ec_like ON public.auth_group USING btree (name varchar_pattern_ops);


ALTER TABLE public."AgentPoint" ADD COLUMN IF NOT EXISTS materials bool NOT NULL;
ALTER TABLE public."TaskType" ADD COLUMN IF NOT EXISTS condition_2 varchar(256) NOT NULL;
ALTER TABLE public."TaskType" ADD COLUMN IF NOT EXISTS grade int2 NOT NULL;
ALTER TABLE public.accounts_user ADD COLUMN IF NOT EXISTS address varchar(255) NOT NULL;
ALTER TABLE public.accounts_user ADD COLUMN IF NOT EXISTS "role" int2 NOT NULL;
ALTER TABLE public.django_admin_log ADD COLUMN IF NOT EXISTS change_message text NOT NULL;
ALTER TABLE public.django_migrations ADD COLUMN IF NOT EXISTS app varchar(255) NOT NULL;
ALTER TABLE public.authtoken_token ADD COLUMN IF NOT EXISTS user_id uuid NOT NULL;
ALTER TABLE public.django_admin_log ADD COLUMN IF NOT EXISTS object_repr varchar(200) NOT NULL;
ALTER TABLE public.django_admin_log ADD  COLUMN IF NOT EXISTS user_id uuid NOT NULL;
ALTER TABLE public.accounts_user_groups ADD COLUMN IF NOT EXISTS user_id uuid NOT NULL;
ALTER TABLE public.django_migrations ADD COLUMN IF NOT EXISTS applied timestamptz NOT NULL;
ALTER TABLE public."AgentPoint" ADD COLUMN IF NOT EXISTS approved_requests int2 NOT NULL;
ALTER TABLE public.accounts_user ADD COLUMN IF NOT EXISTS grade int2 NOT NULL;
ALTER TABLE public."Task" ADD COLUMN IF NOT EXISTS task_type int2 NOT NULL;
ALTER TABLE public.accounts_user_groups ADD COLUMN IF NOT EXISTS id int8 NOT NULL GENERATED BY DEFAULT AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1 NO CYCLE);
ALTER TABLE public.accounts_user ADD COLUMN IF NOT EXISTS is_active bool NOT NULL;
ALTER TABLE public.accounts_user ADD COLUMN IF NOT EXISTS is_superuser bool NOT NULL;
ALTER TABLE public.django_admin_log ADD COLUMN IF NOT EXISTS content_type_id int4 NULL;
ALTER TABLE public."AgentPoint" ADD COLUMN IF NOT EXISTS uuid uuid NOT NULL;
ALTER TABLE public."TaskType" ADD COLUMN IF NOT EXISTS "name" varchar(128) NOT NULL;
ALTER TABLE public.accounts_user ADD COLUMN IF NOT EXISTS last_name varchar(150) NOT NULL;
ALTER TABLE public."AgentPoint" ADD COLUMN IF NOT EXISTS agent_point_date varchar(25) NOT NULL;
ALTER TABLE public.accounts_user ADD COLUMN IF NOT EXISTS username varchar(150) NOT NULL;
ALTER TABLE public.django_content_type ADD COLUMN IF NOT EXISTS model varchar(100) NOT NULL;
ALTER TABLE public."AgentPoint" ADD COLUMN IF NOT EXISTS last_deliver date NOT NULL;
ALTER TABLE public."TaskType" ADD COLUMN IF NOT EXISTS priority int2 NOT NULL;
ALTER TABLE public."AgentPoint" ADD COLUMN IF NOT EXISTS num_given_cards int2 NOT NULL;
ALTER TABLE public."TaskType" ADD COLUMN IF NOT EXISTS work_time int2 NOT NULL;
ALTER TABLE public.django_admin_log ADD COLUMN IF NOT EXISTS action_flag int2 NOT NULL;
ALTER TABLE public."TaskType" ADD COLUMN IF NOT EXISTS condition_1 varchar(256) NOT NULL;
ALTER TABLE public.accounts_user ADD COLUMN IF NOT EXISTS email varchar(255) NOT NULL;
ALTER TABLE public.auth_permission ADD COLUMN IF NOT EXISTS "name" varchar(255) NOT NULL;
ALTER TABLE public.accounts_user ADD COLUMN IF NOT EXISTS date_joined timestamptz NOT NULL;
ALTER TABLE public.accounts_user_user_permissions ADD COLUMN IF NOT EXISTS id int8 NOT NULL GENERATED BY DEFAULT AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1 NO CYCLE);
ALTER TABLE public.django_content_type ADD COLUMN IF NOT EXISTS app_label varchar(100) NOT NULL;
ALTER TABLE public."AgentPoint" ADD COLUMN IF NOT EXISTS address varchar(255) NOT NULL;
ALTER TABLE public.django_session ADD COLUMN IF NOT EXISTS session_key varchar(40) NOT NULL;
ALTER TABLE public."Task" ADD COLUMN IF NOT EXISTS "comment" text NULL;
ALTER TABLE public."AgentPoint" ADD COLUMN IF NOT EXISTS last_stimulation date NOT NULL;
ALTER TABLE public.auth_group_permissions ADD COLUMN IF NOT EXISTS permission_id int4 NOT NULL;
ALTER TABLE public.django_admin_log ADD COLUMN IF NOT EXISTS id int4 NOT NULL GENERATED BY DEFAULT AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE);
ALTER TABLE public.auth_permission ADD COLUMN IF NOT EXISTS content_type_id int4 NOT NULL;
ALTER TABLE public.django_admin_log ADD COLUMN IF NOT EXISTS action_time timestamptz NOT NULL;
ALTER TABLE public."AgentPoint" ADD COLUMN IF NOT EXISTS last_teaching date NOT NULL;
ALTER TABLE public."Task" ADD COLUMN IF NOT EXISTS priority int2 NOT NULL;
ALTER TABLE public.authtoken_token ADD COLUMN IF NOT EXISTS "key" varchar(40) NOT NULL;
ALTER TABLE public.auth_group_permissions ADD COLUMN IF NOT EXISTS group_id int4 NOT NULL;
ALTER TABLE public.accounts_user ADD COLUMN IF NOT EXISTS last_login timestamptz NULL;
ALTER TABLE public.auth_group ADD COLUMN IF NOT EXISTS "name" varchar(150) NOT NULL;
ALTER TABLE public.accounts_user ADD COLUMN IF NOT EXISTS "password" varchar(128) NOT NULL;
ALTER TABLE public.accounts_user ADD COLUMN IF NOT EXISTS first_name varchar(150) NOT NULL;
ALTER TABLE public.accounts_user_user_permissions ADD COLUMN IF NOT EXISTS user_id uuid NOT NULL;
ALTER TABLE public.accounts_user ADD COLUMN IF NOT EXISTS phone_number varchar(32) NOT NULL;
ALTER TABLE public."TaskType" ADD COLUMN IF NOT EXISTS uuid uuid NOT NULL;
ALTER TABLE public."Task" ADD COLUMN IF NOT EXISTS favorite bool NOT NULL;
ALTER TABLE public.accounts_user_user_permissions ADD COLUMN IF NOT EXISTS permission_id int4 NOT NULL;
ALTER TABLE public.auth_group ADD COLUMN IF NOT EXISTS id int4 NOT NULL GENERATED BY DEFAULT AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE);
ALTER TABLE public.django_migrations ADD COLUMN IF NOT EXISTS "name" varchar(255) NOT NULL;
ALTER TABLE public."Task" ADD COLUMN IF NOT EXISTS appointment_date date NULL;
ALTER TABLE public.django_session ADD COLUMN IF NOT EXISTS expire_date timestamptz NOT NULL;
ALTER TABLE public."Task" ADD COLUMN IF NOT EXISTS status int2 NOT NULL;
ALTER TABLE public."Task" ADD COLUMN IF NOT EXISTS uuid uuid NOT NULL;
ALTER TABLE public."Task" ADD COLUMN IF NOT EXISTS employee_id uuid NULL;
ALTER TABLE public.accounts_user ADD COLUMN IF NOT EXISTS middle_name varchar(100) NOT NULL;
ALTER TABLE public."AgentPoint" ADD COLUMN IF NOT EXISTS last_card_given date NULL;
ALTER TABLE public.authtoken_token ADD COLUMN IF NOT EXISTS created timestamptz NOT NULL;
ALTER TABLE public.accounts_user ADD COLUMN IF NOT EXISTS uuid uuid NOT NULL;
ALTER TABLE public.django_admin_log ADD COLUMN IF NOT EXISTS object_id text NULL;
ALTER TABLE public.accounts_user_groups ADD COLUMN IF NOT EXISTS group_id int4 NOT NULL;
ALTER TABLE public.django_session ADD COLUMN IF NOT EXISTS session_data text NOT NULL;
ALTER TABLE public.auth_permission ADD COLUMN IF NOT EXISTS id int4 NOT NULL GENERATED BY DEFAULT AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE);
ALTER TABLE public.accounts_user ADD COLUMN IF NOT EXISTS is_staff bool NOT NULL;
ALTER TABLE public.auth_permission ADD COLUMN IF NOT EXISTS codename varchar(100) NOT NULL;
ALTER TABLE public.django_content_type ADD COLUMN IF NOT EXISTS id int4 NOT NULL GENERATED BY DEFAULT AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE);
ALTER TABLE public.django_migrations ADD COLUMN IF NOT EXISTS id int8 NOT NULL GENERATED BY DEFAULT AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1 NO CYCLE);
ALTER TABLE public.auth_group_permissions ADD COLUMN IF NOT EXISTS id int8 NOT NULL GENERATED BY DEFAULT AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1 NO CYCLE);


INSERT INTO public.accounts_user ("password", last_login, is_superuser, username, first_name, last_name, is_staff, is_active, date_joined, uuid, "role", phone_number, middle_name, email, grade, address) VALUES('pbkdf2_sha256$600000$w0qPh3rCr088OnzMaWPN4h$v13TGZ/U2WBnRYTwpQLcP3iiKm52bENbc57b0C4NiDA=', NULL, false, 'deryagin', 'Никита', 'Дерягин', false, true, '2023-11-09 14:36:25.236', '2e253b9a-7fbf-4ef3-bd89-b06de084aa8f'::uuid, 2, '', 'Владимирович', 'nikita@mail.ru', 3, 'Краснодар, Красная, д. 139');
INSERT INTO public.accounts_user ("password", last_login, is_superuser, username, first_name, last_name, is_staff, is_active, date_joined, uuid, "role", phone_number, middle_name, email, grade, address) VALUES('pbkdf2_sha256$600000$CE81G8FyT9YVrU1Zn6LhGS$IVttV+1ZT1NhIYg4sRBNHw+qkfUz43hKV/MES/IGCO4=', NULL, false, 'petroshev', 'Валерий', 'Петрошев', false, true, '2023-11-09 14:37:55.783', 'da05c4a9-8e6f-43dc-a3b2-6cfd9ab75cda'::uuid, 2, '', 'Павлович', 'valeriy@mail.ru', 2, 'Краснодар, Красная, д. 139');
INSERT INTO public.accounts_user ("password", last_login, is_superuser, username, first_name, last_name, is_staff, is_active, date_joined, uuid, "role", phone_number, middle_name, email, grade, address) VALUES('pbkdf2_sha256$600000$pthV07YK3mL2ay4taq0eau$gkXmhDGzBzVgcketn6GDbMEcr0WntLNJtrdFNJuqdug=', NULL, false, 'david', 'Давид', 'Евдокимов', false, true, '2023-11-09 14:38:35.077', '20275432-2740-4b4c-abf8-ecc909ca97ea'::uuid, 2, '', 'Тихонович', 'david@mail.ru', 1, 'Краснодар, Красная, д. 139');
INSERT INTO public.accounts_user ("password", last_login, is_superuser, username, first_name, last_name, is_staff, is_active, date_joined, uuid, "role", phone_number, middle_name, email, grade, address) VALUES('pbkdf2_sha256$600000$oQQ98kGyUKVW3R2r1UHq6j$uSkoZ6BHKSvG7XZyGW0wB4dzPiDb2TerZLcEhvPL5VU=', NULL, false, 'adam', 'Адам', 'Иванов', false, true, '2023-11-09 14:39:44.525', '2c642334-91ed-42cb-a4fa-590ff930f658'::uuid, 2, '', 'Федорович', 'adam@mail.ru', 2, 'Краснодар, В.Н. Мачуги, 41');
INSERT INTO public.accounts_user ("password", last_login, is_superuser, username, first_name, last_name, is_staff, is_active, date_joined, uuid, "role", phone_number, middle_name, email, grade, address) VALUES('pbkdf2_sha256$600000$vPKbkViRwNZiEzBazqvVfj$beVYdK16NiiByxipXP2X1MSlx3fW/ZKZ4u0atvGDInY=', NULL, false, 'ippolit', 'Ипполит', 'Бобылёв', false, true, '2023-11-09 14:40:10.132', 'd2cb0a29-38b3-462b-a097-684157af2b61'::uuid, 2, '', 'Альбертович', 'ippolit@mail.ru', 1, 'Краснодар, В.Н. Мачуги, 41');
INSERT INTO public.accounts_user ("password", last_login, is_superuser, username, first_name, last_name, is_staff, is_active, date_joined, uuid, "role", phone_number, middle_name, email, grade, address) VALUES('pbkdf2_sha256$600000$Z2BMikMIqFocnDypEIqQYs$Q2T3Q8r5uSEVXtULm3EGQusOkne3S54KUOoKe7xK0AI=', NULL, false, 'v', 'Евгения', 'Беляева', false, true, '2023-11-09 14:40:39.939', '9305e0a7-15ba-4f44-85be-c3d2d15eacf5'::uuid, 2, '', 'Антоновна', 'evgeniya@mail.ru', 2, 'Краснодар, Красных Партизан, 321');
INSERT INTO public.accounts_user ("password", last_login, is_superuser, username, first_name, last_name, is_staff, is_active, date_joined, uuid, "role", phone_number, middle_name, email, grade, address) VALUES('pbkdf2_sha256$600000$snNR0pbhirNAXZ7302nDKU$8aY7zW6KlaxUlVkzjGyOoXJRYfvjUm0lrEdXJ8s3tPg=', NULL, false, 'azariy', 'Азарий', 'Николаев', false, true, '2023-11-09 14:41:07.502', 'cfdaef5a-9d4d-4577-a931-31a9b1d21ae7'::uuid, 2, '', 'Платонович', 'azariy@mail.ru', 1, 'Краснодар, Красных Партизан, 321');


INSERT INTO public."AgentPoint" (uuid, address, agent_point_date, materials, last_card_given, num_given_cards, approved_requests, last_deliver, last_teaching, last_stimulation) VALUES('015c1db9-dd43-472c-9781-0d23abca10ff'::uuid, 'ул. Ставропольская, д. 140', 'давно', True, '2023-09-07', 0, 0, NULL, NULL, NULL);
INSERT INTO public."AgentPoint" (uuid, address, agent_point_date, materials, last_card_given, num_given_cards, approved_requests, last_deliver, last_teaching, last_stimulation) VALUES('49fb327b-33b5-435e-b697-3c2fad52652a'::uuid, 'ул. им. Максима Горького, д. 128', 'давно', True, '2023-09-01', 3, 15, NULL, NULL, NULL);
INSERT INTO public."AgentPoint" (uuid, address, agent_point_date, materials, last_card_given, num_given_cards, approved_requests, last_deliver, last_teaching, last_stimulation) VALUES('f7320554-961d-4d7b-b775-f75141caf21d'::uuid, 'ул. им. Дзержинского, д. 100', 'давно', True, '2023-05-07', 1, 9, NULL, NULL, NULL);
INSERT INTO public."AgentPoint" (uuid, address, agent_point_date, materials, last_card_given, num_given_cards, approved_requests, last_deliver, last_teaching, last_stimulation) VALUES('1254f59b-eee8-465b-8669-b348527191ca'::uuid, 'ул. Красноармейская, д. 126', 'давно', True, '2023-09-07', 15, 30, NULL, NULL, NULL);
INSERT INTO public."AgentPoint" (uuid, address, agent_point_date, materials, last_card_given, num_given_cards, approved_requests, last_deliver, last_teaching, last_stimulation) VALUES('98ec3a0b-b911-427c-84cb-63549c1362fd'::uuid, 'х. Ленина, п/о. 37', 'давно', True, '2023-09-07', 23, 38, NULL, NULL, NULL);
INSERT INTO public."AgentPoint" (uuid, address, agent_point_date, materials, last_card_given, num_given_cards, approved_requests, last_deliver, last_teaching, last_stimulation) VALUES('2d38130c-2dce-4c94-ac4f-92bbb42c03da'::uuid, 'тер. Пашковский жилой массив, ул. Крылатая, д. 2', 'давно', True, '2023-09-07', 0, 14, NULL, NULL, NULL);
INSERT INTO public."AgentPoint" (uuid, address, agent_point_date, materials, last_card_given, num_given_cards, approved_requests, last_deliver, last_teaching, last_stimulation) VALUES('430a6384-c599-4bb1-86b1-47a68c527c5e'::uuid, 'ул. Красных Партизан, д. 439', 'давно', True, '2023-09-07', 1, 19, NULL, NULL, NULL);
INSERT INTO public."AgentPoint" (uuid, address, agent_point_date, materials, last_card_given, num_given_cards, approved_requests, last_deliver, last_teaching, last_stimulation) VALUES('342784c8-e3a7-4d95-b7db-9f46ec16434a'::uuid, 'ул. Восточно-Кругликовская, д. 64/2', 'давно', True, '2023-09-07', 12, 19, NULL, NULL, NULL);
INSERT INTO public."AgentPoint" (uuid, address, agent_point_date, materials, last_card_given, num_given_cards, approved_requests, last_deliver, last_teaching, last_stimulation) VALUES('2aee590b-65ac-4549-9618-55949060bfee'::uuid, 'ул. Красных Партизан, д. 439', 'давно', True, '2023-09-07', 63, 84, NULL, NULL, NULL);
INSERT INTO public."AgentPoint" (uuid, address, agent_point_date, materials, last_card_given, num_given_cards, approved_requests, last_deliver, last_teaching, last_stimulation) VALUES('53acef0f-9b9a-4991-9ce3-7882bb9b3f00'::uuid, 'ул. Таманская, д. 153 к. 3, кв. 2', 'давно', True, '2023-09-07', 1, 15, NULL, NULL, NULL);
INSERT INTO public."AgentPoint" (uuid, address, agent_point_date, materials, last_card_given, num_given_cards, approved_requests, last_deliver, last_teaching, last_stimulation) VALUES('f6c1c680-0659-4b5f-9f1e-305ec5a9e386'::uuid, 'ул. им. Дзержинского, д. 165', 'давно', True, '2023-09-07',0, 19, NULL, NULL, NULL);
INSERT INTO public."AgentPoint" (uuid, address, agent_point_date, materials, last_card_given, num_given_cards, approved_requests, last_deliver, last_teaching, last_stimulation) VALUES('003c8fb2-394f-4f8f-a24b-643078ff6835'::uuid, 'ст-ца. Елизаветинская, ул. Широкая, д. 260', 'давно', True, '2023-09-07', 15, 29, NULL, NULL, NULL);
INSERT INTO public."AgentPoint" (uuid, address, agent_point_date, materials, last_card_given, num_given_cards, approved_requests, last_deliver, last_teaching, last_stimulation) VALUES('1126b3bd-cfba-41ed-81b3-b10e2cb73d3d'::uuid, 'ул. им. Тургенева, д. 174, 1 этаж', 'давно', True, '2023-09-07', 0, 0, NULL, NULL, NULL);
INSERT INTO public."AgentPoint" (uuid, address, agent_point_date, materials, last_card_given, num_given_cards, approved_requests, last_deliver, last_teaching, last_stimulation) VALUES('81d55b75-7bf2-41e6-9d9e-05ea5267d614'::uuid, 'ул. Уральская, д. 162', 'давно', True, '2023-09-07', 5, 21, NULL, NULL, NULL);
INSERT INTO public."AgentPoint" (uuid, address, agent_point_date, materials, last_card_given, num_given_cards, approved_requests, last_deliver, last_teaching, last_stimulation) VALUES('c9a6412b-3896-496a-b6fd-da04884154ad'::uuid, 'ул. Уральская, д. 79/1', 'давно', True, '2023-09-07', 0, 5, NULL, NULL, NULL);
INSERT INTO public."AgentPoint" (uuid, address, agent_point_date, materials, last_card_given, num_given_cards, approved_requests, last_deliver, last_teaching, last_stimulation) VALUES('87143f88-038e-498a-b59d-8dfb0526ef40'::uuid, 'п. Березовый, ул. Целиноградская, д. 6/1', 'давно', True, '2023-09-07', 15, 35, NULL, NULL, NULL);
INSERT INTO public."AgentPoint" (uuid, address, agent_point_date, materials, last_card_given, num_given_cards, approved_requests, last_deliver, last_teaching, last_stimulation) VALUES('ee1a3467-9dc8-4bcf-9e40-6a4914d0ded8'::uuid, 'ул. Красная, д. 154', 'вчера', True, '2023-09-07', 0, 6, NULL, NULL, NULL);
INSERT INTO public."AgentPoint" (uuid, address, agent_point_date, materials, last_card_given, num_given_cards, approved_requests, last_deliver, last_teaching, last_stimulation) VALUES('70fe555d-732a-4230-a302-4c674bf3b42a'::uuid, 'ул. Красная, д. 145', 'вчера', True, '2023-09-07', 6, 18, NULL, NULL, NULL);


INSERT INTO public."TaskType" (uuid, "name", priority, work_time, condition_1, condition_2, grade) VALUES('91f3bf5a-11e2-4963-99b1-e87b9cb1d14c'::uuid, 'Выезд на точку для стимулирования выдач', 3, 4, 'Дата выдачи последней карты более 7 дней назад, при этом есть одобренные заявки', ' ', 3);
INSERT INTO public."TaskType" (uuid, "name", priority, work_time, condition_1, condition_2, grade) VALUES('427c8c88-dc7e-4e89-9ad5-e5d2304e88ae'::uuid, 'Обучение агента', 2, 2, 'Отношение кол-ва выданных карт к одобренным заявкам менее 50%, если выдано больше 0 карт', ' ', 2);
INSERT INTO public."TaskType" (uuid, "name", priority, work_time, condition_1, condition_2, grade) VALUES('2d1a9f3f-8093-4e68-b2b9-3889621a2831'::uuid, 'Доставка карт и материалов', 1, 1, 'Точка подключена вчера', 'Карты и материалы не доставлялись', 1);










