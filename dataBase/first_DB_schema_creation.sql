--TYPES

CREATE TYPE material AS ENUM ('greda', 'pasto natura', 'pasto sintetico','concreto','alfombra','otra');

CREATE TYPE sexo_asignado AS ENUM ('masculino', 'femenino');

create type profesional as enum ('boleador','profesor');

create type tipo_partido as enum ('recreativo', 'ranking', 'torneo');

CREATE TABLE public.institucion (
	id serial4 NOT NULL,
	id_asociacion int4 NOT NULL,
	nombre varchar(50) NOT NULL,
	nombre_corto varchar(5) not NULL,
	ciudad varchar(50) NOT NULL,
	direccion varchar(255) NOT NULL,
	email varchar(255) NOT NULL,
	fecha_fundacion date NULL,
	recoge_bolas bool not null default True,
	recoge_bolas_torneo bool not null default TRUE,
	fecha_creacion timestamp NOT null default Now(),
	activo bool NOT null default TRUE,
	fecha_retiro timestamp NULL,
	CONSTRAINT institucion_email_key UNIQUE (email),
	CONSTRAINT institucion_nombre_key UNIQUE (nombre),
	CONSTRAINT institucion_pkey PRIMARY KEY (id),
	CONSTRAINT institucion_id_asociacion_fkey FOREIGN KEY (id_asociacion) REFERENCES public.asociacion(id)
);

CREATE TABLE public.cancha (
	id serial4 NOT NULL,
	id_institucion int4 NOT NULL,
	nomenclatura varchar NOT NULL,
	superficie material not null default 'greda',
	activo bool NOT null default TRUE,
	fecha_desactivacion timestamp NULL,
	CONSTRAINT nomenclatura_key UNIQUE (nomenclatura),
	CONSTRAINT cancha_pkey PRIMARY KEY (id),
	CONSTRAINT cancha_id_institucion_fkey FOREIGN KEY (id_institucion) REFERENCES public.institucion(id)
);


CREATE TABLE public.recoge_bolas (
	id serial4 NOT NULL,
	id_institucion int4 NOT NULL,
	nombre varchar NOT NULL,
	credencial_institucion varchar not null,
	sexo sexo_asignado not null,
	fecha_nacimiento timestamp null,
	fecha_ingreso timestamp not null default now(),
	activo bool NOT null default TRUE,
	fecha_retiro timestamp NULL,
	CONSTRAINT credencial_key UNIQUE (credencial_institucion),
	CONSTRAINT recoge_bolas_pkey PRIMARY KEY (id),
	CONSTRAINT recoge_bolas_id_institucion_fkey FOREIGN KEY (id_institucion) REFERENCES public.institucion(id)
);


CREATE TABLE public.categoria (
	id serial4 NOT NULL,
	id_institucion int4 NOT NULL,
	nombre varchar NOT NULL,
	tipo profesional not null,
	CONSTRAINT categoria_key UNIQUE (id_institucion, nombre,tipo),
	constraint categoria_pkey primary key (id),
	CONSTRAINT categoria_id_institucion_fkey FOREIGN KEY (id_institucion) REFERENCES public.institucion(id)
)


CREATE TABLE public.profesor (
	id serial4 NOT NULL,
	id_institucion int4 NOT NULL,
	nombre varchar NOT NULL,
	credencial_institucion varchar not null,
	id_categoria int4 not null,
	sexo sexo_asignado not null,
	fecha_nacimiento timestamp null,
	fecha_ingreso timestamp not null default now(),
	boleador bool not null default false,
	activo bool NOT null default TRUE,
	fecha_retiro timestamp NULL,
	CONSTRAINT profesor_key UNIQUE (credencial_institucion),
	CONSTRAINT profesor_pkey PRIMARY KEY (id),
	CONSTRAINT profesor_id_institucion_fkey FOREIGN KEY (id_institucion) REFERENCES public.institucion(id),
	CONSTRAINT profesor_id_categoria_fkey FOREIGN KEY (id_categoria) REFERENCES public.categoria_empleado(id)
);


CREATE TABLE public.deportista (
	id serial4 NOT NULL,
	id_institucion int4 NOT NULL,
	nombre varchar NOT NULL,
	credencial_institucion varchar not null,
	sexo sexo_asignado not null,
	fecha_nacimiento timestamp null,
	fecha_ingreso_institucion timestamp null,
	fecha_ingreso_ramking timestamp not null default now(),
	activo bool NOT null default TRUE,
	fecha_retiro timestamp NULL,
	CONSTRAINT jugador_key UNIQUE (credencial_institucion),
	CONSTRAINT jugador_pkey PRIMARY KEY (id),
	CONSTRAINT jugador_id_institucion_fkey FOREIGN KEY (id_institucion) REFERENCES public.institucion(id)
);

CREATE TABLE public.ranking (
	id serial4 NOT NULL,
	id_deportista int4 NOT NULL,
	puesto int NOT NULL,
	id_categoria int4 not null,
	CONSTRAINT ranking_key UNIQUE (puesto),
	CONSTRAINT ranking_pkey PRIMARY KEY (id),
	CONSTRAINT ranking_id_deportista_fkey FOREIGN KEY (id_deportista) REFERENCES public.deportista(id),
	CONSTRAINT ranking_id_categoria_fkey FOREIGN KEY (id_categoria) REFERENCES public.categoria_ranking(id)
);


CREATE TABLE public.partido (
	id serial8 NOT NULL,
	finalizado bool not null default false,
	fecha_inicio timestamp not null default now(),
	fecha_finalizado timestamp null,
	tipo tipo_partido not null default 'recreativo',
	resultado_partido  integer [5][2],
	puntuacion_partido smallint not null default 0,
	id_deportista_1 int4 NOT NULL,
	id_deportista_2 int4 NOT NULL,
	id_deportista_3 int4 NULL,
	id_deportista_4 int4 NULL,
	dobles bool not null default false,
	CONSTRAINT partido_pkey PRIMARY KEY (id),
	CONSTRAINT partido_id_deportista_1_fkey FOREIGN KEY (id_deportista_1) REFERENCES public.deportista(id),
	CONSTRAINT partido_id_deportista_2_fkey FOREIGN KEY (id_deportista_2) REFERENCES public.deportista(id),
	CONSTRAINT partido_id_deportista_3_fkey FOREIGN KEY (id_deportista_3) REFERENCES public.deportista(id),
	CONSTRAINT partido_id_deportista_4_fkey FOREIGN KEY (id_deportista_4) REFERENCES public.deportista(id)
	);

CREATE TABLE public.puntos (
	id serial8 NOT NULL,
	id_deportista int4 NOT NULL,
	id_partido int NOT NULL,
	fecha_adquicision timestamp not null default now(),
	fecha_vencimiento timestamp not null default now() + interval '1 year',
	CONSTRAINT puntos_pkey PRIMARY KEY (id),
	CONSTRAINT puntos_id_deportista_fkey FOREIGN KEY (id_deportista) REFERENCES public.deportista(id),
	CONSTRAINT puntos_id_partido_fkey FOREIGN KEY (id_partido) REFERENCES public.partido(id)
);

CREATE TABLE public.categoria_empleado(
	id serial4 NOT NULL,
	id_institucion int4 NOT NULL,
	nombre varchar NOT NULL,
	tipo public."profesional" NOT NULL,
	CONSTRAINT categoria_empleado_key UNIQUE (id_institucion, nombre, tipo),
	CONSTRAINT categoria_empleado_pkey PRIMARY KEY (id),
	CONSTRAINT categoria_empleado_id_institucion_fkey FOREIGN KEY (id_institucion) REFERENCES public.institucion(id)
);


CREATE TABLE public.categoria_ranking (
	id serial4 NOT NULL,
	id_institucion int4 NOT NULL,
	nombre varchar NOT NULL,
	juvenil bool not null default False,
	CONSTRAINT categoria_ranking_key UNIQUE (id_institucion, nombre),
	CONSTRAINT categoria_ranking_pkey PRIMARY KEY (id),
	CONSTRAINT categoria_ranking_id_institucion_fkey FOREIGN KEY (id_institucion) REFERENCES public.institucion(id)
);