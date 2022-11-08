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
SET default_tablespace = '';
SET default_with_oids = false;

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;

CREATE TABLE public.cliente (
    dni_cliente character varying(9) NOT NULL,
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
    dni_empleado character varying(9) NOT NULL,
    productividad_emplead integer NOT NULL,
    seguimiento character varying(255) NOT NULL,
    code_zona integer NOT NULL
);


ALTER TABLE public.empleado OWNER TO postgres;

CREATE TABLE public.pedido (
    cantidad integer NOT NULL,
    fechacompra date DEFAULT CURRENT_DATE NOT NULL,
    code_pedido integer NOT NULL,
    dni_empleado character varying(9) NOT NULL,
    dni_cliente character varying(9) NOT NULL
);


ALTER TABLE public.pedido OWNER TO postgres;

CREATE TABLE public.producto (
    code_pedido integer NOT NULL,
    disponibilidad integer NOT NULL,
    code_zona integer NOT NULL
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

ALTER SEQUENCE public.producto_codp_seq OWNED BY public.producto.code_pedido;

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
    code_zona integer NOT NULL,
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

ALTER SEQUENCE public.zona_codz_seq OWNED BY public.zona.code_zona;

ALTER TABLE ONLY public.producto ALTER COLUMN code_pedido SET DEFAULT nextval('public.producto_codp_seq'::regclass);

ALTER TABLE ONLY public.vivero ALTER COLUMN codv SET DEFAULT nextval('public.vivero_codv_seq'::regclass);

ALTER TABLE ONLY public.zona ALTER COLUMN code_zona SET DEFAULT nextval('public.zona_codz_seq'::regclass);

COPY public.cliente (dni_cliente, abonado, bonificacion) FROM stdin;
43835202P	t	20
22222222B	t	25
11111111A	f	0
44444444d	f	0
33333333c	f	0
\.

COPY public.empleado (dni_empleado, productividad_emplead, seguimiento, code_zona) FROM stdin;
12345678A	10	Bueno	1
87654321B	5	Excelente	2
43215678C	25	Malo	3
56784321D	15	Normal	4
12341234E	16	Bueno	5
\.

COPY public.pedido (cantidad, fechacompra, code_pedido, dni_empleado, dni_cliente) FROM stdin;
1	2022-11-02	1	12345678A	11111111A
2	2022-11-02	2	87654321B	22222222B
3	2022-11-02	3	43215678C	33333333c
4	2022-11-02	4	56784321D	44444444d
5	2022-11-02	5	12341234E	33333333c
\.

COPY public.producto (code_pedido, disponibilidad, code_zona) FROM stdin;
1	10	1
2	9	2
3	8	3
4	5	4
5	6	5
\.

COPY public.vivero (codv, nombrev) FROM stdin;
1	Vivero_Tester_1
2	Vivero_Tester_2
3	Vivero_Tester_3
4	Vivero_Tester_4
5	Vivero_Tester_5
\.

COPY public.zona (code_zona, tipoz, productividadz, codv) FROM stdin;
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
    ADD CONSTRAINT cliente_pkey PRIMARY KEY (dni_cliente);

ALTER TABLE ONLY public.empleado
    ADD CONSTRAINT empleado_pkey PRIMARY KEY (dni_empleado);

ALTER TABLE ONLY public.pedido
    ADD CONSTRAINT pedido_pkey PRIMARY KEY (code_pedido, dni_empleado, dni_cliente);

ALTER TABLE ONLY public.producto
    ADD CONSTRAINT producto_pkey PRIMARY KEY (code_pedido);

ALTER TABLE ONLY public.vivero
    ADD CONSTRAINT vivero_nombrev_key UNIQUE (nombrev);

ALTER TABLE ONLY public.vivero
    ADD CONSTRAINT vivero_pkey PRIMARY KEY (codv);

ALTER TABLE ONLY public.zona
    ADD CONSTRAINT zona_pkey PRIMARY KEY (code_zona);

ALTER TABLE ONLY public.empleado
    ADD CONSTRAINT empleado_codz_fkey FOREIGN KEY (code_zona) REFERENCES public.zona(code_zona);

ALTER TABLE ONLY public.pedido
    ADD CONSTRAINT pedido_codp_fkey FOREIGN KEY (code_pedido) REFERENCES public.producto(code_pedido);

ALTER TABLE ONLY public.pedido
    ADD CONSTRAINT pedido_dni_cliente_fkey FOREIGN KEY (dni_cliente) REFERENCES public.cliente(dni_cliente);

ALTER TABLE ONLY public.pedido
    ADD CONSTRAINT pedido_dni_empleado_fkey FOREIGN KEY (dni_empleado) REFERENCES public.empleado(dni_empleado);

ALTER TABLE ONLY public.producto
    ADD CONSTRAINT producto_codz_fkey FOREIGN KEY (code_zona) REFERENCES public.zona(code_zona);

ALTER TABLE ONLY public.zona
    ADD CONSTRAINT zona_codv_fkey FOREIGN KEY (codv) REFERENCES public.vivero(codv);