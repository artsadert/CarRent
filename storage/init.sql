CREATE EXTENSION postgis;

CREATE TABLE IF NOT EXISTS "cars" (
	"id" serial primary key,
	"model_id" bigint NOT NULL,
	"release_year" smallint NOT NULL,
	"license_plate" varchar(20) NOT NULL UNIQUE,
	"vin" varchar(17) NOT NULL UNIQUE,
	"color" varchar(50) NOT NULL,
	"luxury_category_id" bigint NOT NULL,
	"fuel_type" varchar(20) NOT NULL,
	"drive" varchar(20) NOT NULL,
	"rate" numeric(3, 2),
	"value" bigint NOT NULL,
	"current_mileage" numeric(10, 2) NOT NULL,
	"last_maintenance_date" date,
	"next_maintenance_date" date,
	"parking_id" bigint NOT NULL,
	"current_location" geography(POINT, 4326) NOT NULL,
	"owner_id" bigint NOT NULL,
	"is_checked" boolean NOT NULL DEFAULT false,
	"created_at" timestamp with time zone NOT NULL DEFAULT now(),
	"updated_at" timestamp with time zone NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS "users" (
	"id" serial primary key,
	"name" varchar(255) NOT NULL,
	"lname" varchar(255) NOT NULL,
	"mname" varchar(255),
	"email" varchar(255) NOT NULL,
	"phone" bigint NOT NULL,
	"main_payment_id" bigint,
	"date_of_birth" date,
	"driver_license_number" varchar(50) NOT NULL UNIQUE,
	"driver_license_expiration" date NOT NULL,
	"driver_license_photo" bytea NOT NULL,
	"is_verified" boolean NOT NULL DEFAULT false,
	"is_active" boolean NOT NULL,
	"created_at" timestamp with time zone NOT NULL DEFAULT now(),
	"updated_at" timestamp with time zone NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS "payments" (
	"id" serial primary key,
	"user_id" bigint NOT NULL,
	"number" varchar(16) NOT NULL,
	"expiration_date" date NOT NULL,
	"cvc" varchar(3) NOT NULL,
	"created_at" timestamp with time zone NOT NULL DEFAULT now(),
	"updated_at" timestamp with time zone NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS "car_categories" (
	"id" serial primary key,
	"name" varchar(100) NOT NULL,
	"category_multiplier" numeric(4,2) NOT NULL DEFAULT '1.0',
	"created_at" timestamp with time zone NOT NULL DEFAULT now(),
	"updated_at" timestamp with time zone NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS "parking_areas" (
	"id" serial primary key,
  "name" varchar(100) NOT NULL,
  "location" geometry(POLYGON, 4326) NOT NULL,
	"car_capacity" bigint NOT NULL,
	"is_available" boolean NOT NULL default false,
	"created_at" timestamp with time zone NOT NULL DEFAULT now(),
	"updated_at" timestamp with time zone NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS "rentals" (
	"id" serial primary key,
	"car_id" bigint NOT NULL,
	"user_id" bigint NOT NULL,
	"started_at" timestamp with time zone NOT NULL DEFAULT now(),
	"finished_at" timestamp with time zone,
	"created_at" timestamp with time zone NOT NULL DEFAULT now(),
	"updated_at" timestamp with time zone NOT NULL DEFAULT now(),
	"minute_fee" numeric(8,2) NOT NULL
);

CREATE TABLE IF NOT EXISTS "damages" (
	"id" serial primary key,
	"car_id" bigint NOT NULL,
	"name" varchar(100) NOT NULL,
	"photo" bytea NOT NULL,
	"discription" varchar(2000),
	"value" numeric(15,2),
	"is_repaired" boolean NOT NULL DEFAULT false,
	"created_at" timestamp with time zone NOT NULL DEFAULT now(),
	"updated_at" timestamp with time zone NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS "reviews" (
	"id" serial primary key,
	"rental_id" bigint NOT NULL,
	"rate" smallint NOT NULL check(rate between 0 and 6),
	"car_rate" smallint check(car_rate between 0 and 6 or car_rate is null),
	"parking_rate" smallint check(parking_rate between 0 and 6 or parking_rate is null),
	"created_at" timestamp with time zone NOT NULL DEFAULT now(),
	"updated_at" timestamp with time zone NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS "models" (
	"id" serial primary key,
	"name" varchar(50) NOT NULL,
	"discription" varchar(2000) NOT NULL,
	"model_multiplier" numeric(3,2) NOT NULL DEFAULT '1.0',
	"mark_id" bigint NOT NULL,
	"created_at" timestamp with time zone NOT NULL DEFAULT now(),
	"updated_at" timestamp with time zone NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS "marks" (
	"id" serial primary key,
	"name" varchar(255) NOT NULL,
	"discription" varchar(255) NOT NULL,
	"mark_multipier" numeric(5,2) NOT NULL DEFAULT '1.0',
	"created_at" timestamp with time zone NOT NULL DEFAULT now(),
	"updated_at" timestamp with time zone NOT NULL DEFAULT now()
);

ALTER TABLE "cars" ADD CONSTRAINT "cars_fk1" FOREIGN KEY ("model_id") REFERENCES "models"("id");

ALTER TABLE "cars" ADD CONSTRAINT "cars_fk6" FOREIGN KEY ("luxury_category_id") REFERENCES "car_categories"("id");

ALTER TABLE "cars" ADD CONSTRAINT "cars_fk14" FOREIGN KEY ("parking_id") REFERENCES "parking_areas"("id");

ALTER TABLE "cars" ADD CONSTRAINT "cars_fk16" FOREIGN KEY ("owner_id") REFERENCES "users"("id");
ALTER TABLE "users" ADD CONSTRAINT "users_fk6" FOREIGN KEY ("main_payment_id") REFERENCES "payments"("id");
ALTER TABLE "payments" ADD CONSTRAINT "payments_fk1" FOREIGN KEY ("user_id") REFERENCES "users"("id");


ALTER TABLE "rentals" ADD CONSTRAINT "rentals_fk1" FOREIGN KEY ("car_id") REFERENCES "cars"("id");

ALTER TABLE "rentals" ADD CONSTRAINT "rentals_fk2" FOREIGN KEY ("user_id") REFERENCES "users"("id");
ALTER TABLE "damages" ADD CONSTRAINT "damages_fk1" FOREIGN KEY ("car_id") REFERENCES "cars"("id");
ALTER TABLE "reviews" ADD CONSTRAINT "reviews_fk1" FOREIGN KEY ("rental_id") REFERENCES "rentals"("id");
ALTER TABLE "model" ADD CONSTRAINT "model_fk4" FOREIGN KEY ("mark_id") REFERENCES "marks"("id");



insert into parking_areas(car_capacity, is_available, location, name) values(1500, true, ST_GeomFromText(
	'SRID=4326;POLYGON((
		39.947834 43.413836,
		39.945063 43.414035,
        39.942888 43.414973,
        39.945152 43.416445,
        39.946863 43.416197,
        39.947834 43.413836
	))'
)::geography, 'Парковка у Пнишки')

insert into parking_areas(car_capacity, is_available, location, name) values(200, true, ST_GeomFromText(
	'SRID=4326;POLYGON((
		39.947834 43.413836,
		39.945063 43.414035,
        39.942888 43.414973,
        39.945152 43.416445,
        39.946863 43.416197,
        39.947834 43.413836
	))'
)::geography, 'Парковка около парка')

insert into marks(name, discription, mark_multipier) values('toyota', 'Японская фирма по производству автомобилей', 1.0)

insert into models(name, discription, model_multiplier, mark_id) values('Prius', 'Малая электрическая тачка', 1.2, 1)

insert into users(name, lname, email, phone, date_of_birth, driver_license_number, driver_license_expiration, driver_license_photo, is_verified, is_active)
values('Arthur', 'Sadertdinov', 'artsadert@gmail.com', '+79892494749', '04-28-2007'::date, '452348293', '07-28-2028'::date, 'fdasfsds'::bytea, true, false)

insert into payments(user_id, number, expiration_date, cvc) values(1, '0000111122223333', '01-01-2026'::date, '012')

insert into car_categories(name, category_multiplier) values('Regular', 1.0)
insert into car_categories(name, category_multiplier) values('Luxury', 2.0)

insert into cars(model_id, release_year, license_plate, vin, color, luxury_category_id, fuel_type, drive, value, current_mileage, parking_id, current_location, owner_id, is_checked)
values(1, 2007, '201-202802323', '1209823409', 'Gray', 1, 'petrol', 'front', 500000, 10000, 1, ST_GeomFromText('SRID=4326;POINT(39.932441 43.417478)')::geography, 1, true)

insert into rentals(car_id, user_id, started_at, finished_at, minute_fee) values(1, 1, now() - '2 hour'::interval, now(), 6.0)

create or replace function get_cost_of_rent(rent_id integer) 
returns numeric
language plpgsql
as
$$
	declare
		res numeric;
	begin
		select extract(epoch from (finished_at - started_at)) / 60 * minute_fee  into res from rentals where rentals.id = rent_id;
		return res;
	end
$$;

insert into damages(car_id, name, photo, discription, value, is_repaired) values(1, 'broked wheel', 'test'::bytea, 'nail in wheel', 20000, true)

insert into reviews(rental_id, rate) values(1, 5)
