SET lock_timeout = 0;
SET row_security = off;
SET xmloption = content;
SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET check_function_bodies = false;
SET client_min_messages = warning;
SET standard_conforming_strings = on;
SET idle_in_transaction_session_timeout = 0;
SELECT pg_catalog.set_config('search_path', '', false);

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;

SET default_tablespace = '';
SET default_with_oids = false;

CREATE TABLE public.cliente (
    dnic character varying(9) NOT NULL,
    abonado boolean DEFAULT false NOT NULL,
    bonificacion integer DEFAULT 0,
    CONSTRAINT ck_bonificacion CHECK (
CASE
    WHEN (abonado = false) THEN (bonificacion = 0)
    ELSE NULL::boolean
END)
);


ALTER TABLE public.cliente OWNER TO postgres;

CREATE TABLE public.empleado (
    dnie character varying(9) NOT NULL,
    productividade integer NOT NULL,
    seguimiento character varying(255) NOT NULL,
    codz integer NOT NULL
);


ALTER TABLE public.empleado OWNER TO postgres;

CREATE TABLE public.pedido (
    cantidad integer NOT NULL,
    fechacompra date DEFAULT CURRENT_DATE NOT NULL,
    codp integer NOT NULL,
    dnie character varying(9) NOT NULL,
    dnic character varying(9) NOT NULL
);


ALTER TABLE public.pedido OWNER TO postgres;

CREATE TABLE public.producto (
    codp integer NOT NULL,
    disponibilidad integer NOT NULL,
    codz integer NOT NULL
);


ALTER TABLE public.producto OWNER TO postgres;


CREATE SEQUENCE public.producto_codp_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.producto_codp_seq OWNER TO postgres;

ALTER SEQUENCE public.producto_codp_seq OWNED BY public.producto.codp;

CREATE TABLE public.vivero (
    codv integer NOT NULL,
    nombrev character varying(255) NOT NULL
);


ALTER TABLE public.vivero OWNER TO postgres;

CREATE SEQUENCE public.vivero_codv_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.vivero_codv_seq OWNER TO postgres;

ALTER SEQUENCE public.vivero_codv_seq OWNED BY public.vivero.codv;

CREATE TABLE public.zona (
    codz integer NOT NULL,
    tipoz character varying(255) NOT NULL,
    productividadz integer,
    codv integer NOT NULL
);


ALTER TABLE public.zona OWNER TO postgres;

CREATE SEQUENCE public.zona_codz_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.zona_codz_seq OWNER TO postgres;

ALTER SEQUENCE public.zona_codz_seq OWNED BY public.zona.codz;

ALTER TABLE ONLY public.producto ALTER COLUMN codp SET DEFAULT nextval('public.producto_codp_seq'::regclass);

ALTER TABLE ONLY public.vivero ALTER COLUMN codv SET DEFAULT nextval('public.vivero_codv_seq'::regclass);

ALTER TABLE ONLY public.zona ALTER COLUMN codz SET DEFAULT nextval('public.zona_codz_seq'::regclass);

COPY public.cliente (dnic, abonado, bonificacion) FROM stdin;
43835202P	t	20
22222222B	t	25
11111111A	f	0
44444444d	f	0
33333333c	f	0
\.

COPY public.empleado (dnie, productividade, seguimiento, codz) FROM stdin;
12345678A	10	Bueno	1
87654321B	5	Excelente	2
43215678C	25	Malo	3
56784321D	15	Normal	4
12341234E	16	Bueno	5
\.

COPY public.pedido (cantidad, fechacompra, codp, dnie, dnic) FROM stdin;
1	2022-11-02	1	12345678A	11111111A
2	2022-11-02	2	87654321B	22222222B
3	2022-11-02	3	43215678C	33333333c
4	2022-11-02	4	56784321D	44444444d
5	2022-11-02	5	12341234E	33333333c
\.

COPY public.producto (codp, disponibilidad, codz) FROM stdin;
1	10	1
2	9	2
3	8	3
4	5	4
5	6	5
\.

COPY public.vivero (codv, nombrev) FROM stdin;
1	Vivero1
2	ViveroMarcos
3	ViveroHector
4	ViveroRamon
5	ViveroJoseCarlos
\.

COPY public.zona (codz, tipoz, productividadz, codv) FROM stdin;
1	Exterior	10	1
2	Interior	5	2
3	Cajas	7	3
4	Almacen	6	4
5	Exterior	9	5
\.

SELECT pg_catalog.setval('public.producto_codp_seq', 5, true);

SELECT pg_catalog.setval('public.vivero_codv_seq', 5, true);

SELECT pg_catalog.setval('public.zona_codz_seq', 5, true);

ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT cliente_pkey PRIMARY KEY (dnic);

ALTER TABLE ONLY public.empleado
    ADD CONSTRAINT empleado_pkey PRIMARY KEY (dnie);

ALTER TABLE ONLY public.pedido
    ADD CONSTRAINT pedido_pkey PRIMARY KEY (codp, dnie, dnic);

ALTER TABLE ONLY public.producto
    ADD CONSTRAINT producto_pkey PRIMARY KEY (codp);

ALTER TABLE ONLY public.vivero
    ADD CONSTRAINT vivero_nombrev_key UNIQUE (nombrev);

ALTER TABLE ONLY public.vivero
    ADD CONSTRAINT vivero_pkey PRIMARY KEY (codv);

ALTER TABLE ONLY public.zona
    ADD CONSTRAINT zona_pkey PRIMARY KEY (codz);

ALTER TABLE ONLY public.empleado
    ADD CONSTRAINT empleado_codz_fkey FOREIGN KEY (codz) REFERENCES public.zona(codz);

ALTER TABLE ONLY public.pedido
    ADD CONSTRAINT pedido_codp_fkey FOREIGN KEY (codp) REFERENCES public.producto(codp);

ALTER TABLE ONLY public.pedido
    ADD CONSTRAINT pedido_dnic_fkey FOREIGN KEY (dnic) REFERENCES public.cliente(dnic);

ALTER TABLE ONLY public.pedido
    ADD CONSTRAINT pedido_dnie_fkey FOREIGN KEY (dnie) REFERENCES public.empleado(dnie);

ALTER TABLE ONLY public.producto
    ADD CONSTRAINT producto_codz_fkey FOREIGN KEY (codz) REFERENCES public.zona(codz);

ALTER TABLE ONLY public.zona
    ADD CONSTRAINT zona_codv_fkey FOREIGN KEY (codv) REFERENCES public.vivero(codv);