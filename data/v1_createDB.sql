-- TODO 1.3 : Créer les tables manquantes et modifier celles ci-dessous
create table LesSpectacles (
    noSpec integer not null,
    nomSpec varchar(50) not null,
    prixBaseSpec integer not null,
    constraint pk_spec_noSpec primary key (noSpec),
    constraint ck_spec_prixBaseSpec check (prixBaseSpec >=0),
    constraint ck_spec_noSpec check (noSpec > 0)
);

create table LesRepresentations_base (
    dateRep date not null,
    promoRep integer not null,
    noSpec integer not null,
    constraint pk_rep_dateRep primary key (dateRep,noSpec),
    constraint fk_rep_noSpec foreign key (noSpec) references LesSpectacles(noSpec),
    constraint ck_rep_promoRep check (promoRep >= 0 and promoRep <=1)
);

create table LesZones (
    noZone integer not null,
    catZone varchar (50) not null,
    tauxZone integer not null,
    constraint pk_zon_noZon primary key (noZone),
    constraint ck_pl_noZone check (noZone >= 0),
    constraint ck_pl_cat check (catZone in ('orchestre', 'balcon', 'poulailler')),
    constraint ck_pl_tauxZone check (tauxZone >= 0)
);

create table LesPlaces (
    noPlace integer not null,
    noRang integer not null,
    noZone integer not null,
    constraint pk_pl_noP_noR primary key (noPlace, noRang),
    constraint fk_pl_noZon foreign key (noZone) references LesZones(noZone),
    constraint ck_pl_noP check (noPlace > 0),
    constraint ck_pl_noR check (noRang > 0)
);

create table LesReductions (
    catRed varchar(50) not null,
    pctRed integer not null,
    constraint pk_red_cat primary key (catRed),
    constraint ck_red_pct check (pctRed >= 0 and pctRed <1)
);

create table LesDossiers_base (
    noDossier integer not null,
    dateAchat date not null,
    constraint pk_dos_noD_date primary key (noDossier),
    constraint ck_dos_noD check (noDossier > 0)
);

create table LesVentes (
    noPlace integer not null,
    noRang integer not null,
    dateRep date not null,
    noDossier integer not null,
    catRed integer not null,
    constraint pk_vent_noR_noP_dateR primary key (noPlace, noRang, dateRep),
    constraint fk_vent_noP foreign key (noPlace,noRang) references LesPlaces(noPlace,noRang),
    constraint fk_vent_dateR foreign key (dateRep) references LesRepresentations_base (dateRep),
    constraint fk_vent_noD foreign key (noDossier) references LesDossier (noDossier),
    constraint fk_vent_catRed foreign key (catRed) references LesReductions (catRed)
);

create view LesRepresentations AS
    SELECT dateRep, promoRep, prixBaseSpec*promoRep as prixRep, noSpec FROM LesRepresentations_base join LesSpectacles USING (noSpec);

create view LesDossiers_0 AS
    SELECT noDossier, dateAchat, prixRep*tauxZone*(1-pctRed) as prixPlace FROM LesDossiers_base join LesVentes using (noDossier)
     join LesPlaces using (noPlace,noRang) join LesReductions using(catRed)
     join LesZones using (noZone) join LesRepresentations using (dateRep);

create view LesDossiers AS
    SELECT noDossier, SUM(prixPlace) as prixGlobal, dateAchat FROM LesDossiers_0 GROUP BY noDossier;
-- TODO 1.4 : Créer une vue LesRepresentations ajoutant le nombre de places disponible et d'autres possibles attributs calculés.
-- TODO 1.5 : Créer une vue  avec le noDos et le montant total correspondant.
-- TODO 3.3 : Ajouter les éléments nécessaires pour créer le trigger (attention, syntaxe SQLite différent qu'Oracle)