SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: refresh_customer_details(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.refresh_customer_details() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
      BEGIN
        REFRESH MATERIALIZED VIEW CONCURRENTLY customer_details;
        RETURN NULL;
      EXCEPTION
        WHEN feature_not_supported THEN
          RETURN NULL;
      END $$;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: addresses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.addresses (
    id bigint NOT NULL,
    street character varying NOT NULL,
    city character varying NOT NULL,
    zipcode character varying NOT NULL,
    state_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.addresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.addresses_id_seq OWNED BY public.addresses.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: customers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.customers (
    id bigint NOT NULL,
    first_name character varying NOT NULL,
    last_name character varying NOT NULL,
    email character varying NOT NULL,
    username character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: customers_billing_addresses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.customers_billing_addresses (
    id bigint NOT NULL,
    customer_id bigint,
    address_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: customers_shipping_addresses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.customers_shipping_addresses (
    id bigint NOT NULL,
    customer_id bigint,
    address_id bigint,
    "primary" boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: states; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.states (
    id bigint NOT NULL,
    code character varying NOT NULL,
    name character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: customer_details; Type: MATERIALIZED VIEW; Schema: public; Owner: -
--

CREATE MATERIALIZED VIEW public.customer_details AS
 SELECT customers.id AS customer_id,
    customers.first_name,
    customers.last_name,
    customers.email,
    customers.username,
    customers.created_at AS joined_at,
    billing_address.id AS billing_address_id,
    billing_address.street AS billing_street,
    billing_address.city AS billing_city,
    billing_state.code AS billing_state,
    billing_address.zipcode AS billing_zipcode,
    shipping_address.id AS shipping_address_id,
    shipping_address.street AS shipping_street,
    shipping_address.city AS shipping_city,
    shipping_state.code AS shipping_state,
    shipping_address.zipcode AS shipping_zipcode
   FROM ((((((public.customers
     JOIN public.customers_billing_addresses ON ((customers.id = customers_billing_addresses.customer_id)))
     JOIN public.addresses billing_address ON ((billing_address.id = customers_billing_addresses.address_id)))
     JOIN public.states billing_state ON ((billing_address.state_id = billing_state.id)))
     JOIN public.customers_shipping_addresses ON (((customers.id = customers_shipping_addresses.customer_id) AND (customers_shipping_addresses."primary" = true))))
     JOIN public.addresses shipping_address ON ((shipping_address.id = customers_shipping_addresses.address_id)))
     JOIN public.states shipping_state ON ((shipping_address.state_id = shipping_state.id)))
  WITH NO DATA;


--
-- Name: customers_billing_addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.customers_billing_addresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: customers_billing_addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.customers_billing_addresses_id_seq OWNED BY public.customers_billing_addresses.id;


--
-- Name: customers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.customers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: customers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.customers_id_seq OWNED BY public.customers.id;


--
-- Name: customers_shipping_addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.customers_shipping_addresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: customers_shipping_addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.customers_shipping_addresses_id_seq OWNED BY public.customers_shipping_addresses.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: states_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.states_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: states_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.states_id_seq OWNED BY public.states.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    CONSTRAINT email_must_be_company_email CHECK (((email)::text ~* '^[^@]+@example.com'::text))
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.addresses ALTER COLUMN id SET DEFAULT nextval('public.addresses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customers ALTER COLUMN id SET DEFAULT nextval('public.customers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customers_billing_addresses ALTER COLUMN id SET DEFAULT nextval('public.customers_billing_addresses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customers_shipping_addresses ALTER COLUMN id SET DEFAULT nextval('public.customers_shipping_addresses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.states ALTER COLUMN id SET DEFAULT nextval('public.states_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT addresses_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: customers_billing_addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customers_billing_addresses
    ADD CONSTRAINT customers_billing_addresses_pkey PRIMARY KEY (id);


--
-- Name: customers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (id);


--
-- Name: customers_shipping_addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customers_shipping_addresses
    ADD CONSTRAINT customers_shipping_addresses_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: states_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.states
    ADD CONSTRAINT states_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: customer_details_customer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX customer_details_customer_id ON public.customer_details USING btree (customer_id);


--
-- Name: index_addresses_on_state_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_addresses_on_state_id ON public.addresses USING btree (state_id);


--
-- Name: index_customers_billing_addresses_on_address_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_customers_billing_addresses_on_address_id ON public.customers_billing_addresses USING btree (address_id);


--
-- Name: index_customers_billing_addresses_on_customer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_customers_billing_addresses_on_customer_id ON public.customers_billing_addresses USING btree (customer_id);


--
-- Name: index_customers_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_customers_on_email ON public.customers USING btree (email);


--
-- Name: index_customers_on_lower_email; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_customers_on_lower_email ON public.customers USING btree (lower((email)::text));


--
-- Name: index_customers_on_lower_first_name_varchar_pattern_ops; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_customers_on_lower_first_name_varchar_pattern_ops ON public.customers USING btree (lower((first_name)::text) varchar_pattern_ops);


--
-- Name: index_customers_on_lower_last_name_varchar_pattern_ops; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_customers_on_lower_last_name_varchar_pattern_ops ON public.customers USING btree (lower((last_name)::text) varchar_pattern_ops);


--
-- Name: index_customers_on_username; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_customers_on_username ON public.customers USING btree (username);


--
-- Name: index_customers_shipping_addresses_on_address_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_customers_shipping_addresses_on_address_id ON public.customers_shipping_addresses USING btree (address_id);


--
-- Name: index_customers_shipping_addresses_on_customer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_customers_shipping_addresses_on_customer_id ON public.customers_shipping_addresses USING btree (customer_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token);


--
-- Name: refresh_customer_details; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER refresh_customer_details AFTER INSERT OR DELETE OR UPDATE ON public.customers FOR EACH STATEMENT EXECUTE PROCEDURE public.refresh_customer_details();


--
-- Name: refresh_customer_details; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER refresh_customer_details AFTER INSERT OR DELETE OR UPDATE ON public.customers_shipping_addresses FOR EACH STATEMENT EXECUTE PROCEDURE public.refresh_customer_details();


--
-- Name: refresh_customer_details; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER refresh_customer_details AFTER INSERT OR DELETE OR UPDATE ON public.customers_billing_addresses FOR EACH STATEMENT EXECUTE PROCEDURE public.refresh_customer_details();


--
-- Name: refresh_customer_details; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER refresh_customer_details AFTER INSERT OR DELETE OR UPDATE ON public.addresses FOR EACH STATEMENT EXECUTE PROCEDURE public.refresh_customer_details();


--
-- Name: fk_rails_03434abdec; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customers_shipping_addresses
    ADD CONSTRAINT fk_rails_03434abdec FOREIGN KEY (address_id) REFERENCES public.addresses(id);


--
-- Name: fk_rails_1acf477a07; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customers_billing_addresses
    ADD CONSTRAINT fk_rails_1acf477a07 FOREIGN KEY (address_id) REFERENCES public.addresses(id);


--
-- Name: fk_rails_24feede977; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customers_shipping_addresses
    ADD CONSTRAINT fk_rails_24feede977 FOREIGN KEY (customer_id) REFERENCES public.customers(id);


--
-- Name: fk_rails_2d87b6c11e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT fk_rails_2d87b6c11e FOREIGN KEY (state_id) REFERENCES public.states(id);


--
-- Name: fk_rails_32e2e952a9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customers_billing_addresses
    ADD CONSTRAINT fk_rails_32e2e952a9 FOREIGN KEY (customer_id) REFERENCES public.customers(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20181006025135'),
('20181006064844'),
('20181006095001'),
('20181007035852'),
('20181014095038'),
('20181014095132'),
('20181014095255'),
('20181014095340'),
('20181014115806'),
('20181021042425'),
('20181021054033');


