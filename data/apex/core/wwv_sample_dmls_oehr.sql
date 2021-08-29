Rem  Copyright (c) Oracle Corporation 2010 - 2018. All Rights Reserved.
Rem
Rem    NAME
Rem      wwv_sample_dmls_oehr.sql
Rem
Rem    DESCRIPTION
Rem      Insert Sample datasets during APEX installation
Rem
Rem    IMPORTANT: If DML lengh > 4000, DML cannot exceed 255 chars per line.
Rem               When DML > 4000, install uses varchar2 255 array to execute DDL.
Rem

Rem    MODIFIED     (MM/DD/YYYY)
Rem    dpeake       01/10/2018 - Created
Rem    dpeake       07/18/2018 - Added inserts into JSON Table (Feature #2365)
Rem    dpeake       08/03/2018 - Remove Globalizations from JSON (Feature #2365)
Rem    dpeake       08/03/2018 - Update date formats to use MM instead of MON

set define '^'
prompt ...Application Express Sample installation of datasets

prompt
prompt ...insert into wwv_sample_dmls - HR Data
prompt

declare
  l_clob clob;
begin
    -- Insert into JSON Table
    delete from wwv_sample_json
    where wwv_sample_dataset_id = 3;

    l_clob :=q'~{
        "application": {
          "name": "Demonstation - HR",
          "appShortDescription": "Generated based on a Sample Dataset!",
          "appDescription": "This application was generated directly from Sample Datasets. Go to SQL Workshop > Utilities > Sample Datasets to install tables and then create an application based on those tables.",
          "features": {
            "accessControl": true,
            "activityReporting": true,
            "configurationOptions": true,
            "feedback": true,
            "helpPages": true,
            "themeSelection": true
            },
          "appearance": {
            "themeStyle": "Vita",
            "navigation": "SIDE",
            "icon": "app-icon-people",
            "iconBackgroundClass": "app-color-1",
            "iconColorHEX": "#309FDB"
            },
          "settings": {
            "baseTablePrefix": "OEHR",
            "primaryLanguage": "en",
            "authentication": "Application Express"
            },
          "pages": [
            {
              "page": "1",
              "pageType": "blank",
              "pageName": "Home",
              "pageIcon": "fa-home",
              "pageIsHomePage": true,
              "help": ""
            }
            ,
            {
              "page": "2",
              "pageType": "dashboard",
              "pageName": "Dashboard",
              "pageIcon": "fa-dashboard",
              "help": "",
              "dashboardWidgets": [
              {
                "name": "Total Customer Orders",
                "type": "bar",
                "table": "OEHR_ORDERS",
                "labelColumn": "CUSTOMER_ID",
                "valueColumn": "ORDER_TOTAL",
                "valueDerivation": "sum"
              }
              ,
              {
                "name": "Total Sales Rep Orders",
                "type": "bar",
                "table": "OEHR_ORDERS",
                "labelColumn": "SALES_REP_ID",
                "valueColumn": "ORDER_TOTAL",
                "valueDerivation": "sum"
              }
              ,
              {
                "name": "Customer Credit Limits",
                "type": "bar",
                "table": "OEHR_CUSTOMERS",
                "labelColumn": "CUST_LAST_NAME",
                "valueColumn": "CREDIT_LIMIT",
                "valueDerivation": "columnValue"
              }
              ,
              {
                "name": "Order Statuses",
                "type": "pie",
                "table": "OEHR_ORDERS",
                "labelColumn": "ORDER_STATUS",
                "valueColumn": "allColumns",
                "valueDerivation": "count"
              }
              ]
            }
            ,
            {
              "page": "3",
              "pageType": "interactiveReport",
              "pageName": "Departments",
              "pageIcon": "fa-table",
              "reportImplementation": "TABLE",
              "table": "OEHR_DEPARTMENTS",
              "includeFormWithReport": true,
              "foreignKeyRelationships": [
                {
                  "foreignKeyColumn": "LOCATION_ID",
                  "detailTable": "OEHR_LOCATIONS",
                  "detailTableKeyColumn": "LOCATION_ID",
                  "detailTableDisplayColumn": "CITY"
                }
                ,
                {
                  "foreignKeyColumn": "MANAGER_ID",
                  "detailTable": "OEHR_EMPLOYEES",
                  "detailTableKeyColumn": "EMPLOYEE_ID",
                  "detailTableDisplayColumn": "LAST_NAME"
                }
              ],
              "help": ""
            }
            ,
            {
              "page": "4",
              "pageType": "interactiveReport",
              "pageName": "Jobs",
              "pageIcon": "fa-table",
              "reportImplementation": "TABLE",
              "table": "OEHR_JOBS",
              "includeFormWithReport": true,
              "help": ""
            }
            ,
            {
              "page": "5",
              "pageType": "interactiveReport",
              "pageName": "Employees",
              "pageIcon": "fa-table",
              "reportImplementation": "TABLE",
              "table": "OEHR_EMPLOYEES",
              "includeFormWithReport": true,
              "foreignKeyRelationships": [
                {
                  "foreignKeyColumn": "DEPARTMENT_ID",
                  "detailTable": "OEHR_DEPARTMENTS",
                  "detailTableKeyColumn": "DEPARTMENT_ID",
                  "detailTableDisplayColumn": "DEPARTMENT_NAME"
                }
                ,
                {
                  "foreignKeyColumn": "JOB_ID",
                  "detailTable": "OEHR_JOBS",
                  "detailTableKeyColumn": "JOB_ID",
                  "detailTableDisplayColumn": "JOB_TITLE"
                }
                ,
                {
                  "foreignKeyColumn": "MANAGER_ID",
                  "detailTable": "OEHR_EMPLOYEES",
                  "detailTableKeyColumn": "EMPLOYEE_ID",
                  "detailTableDisplayColumn": "LAST_NAME"
                }
              ],
              "help": ""
            }
            ,
            {
              "page": "6",
              "pageType": "interactiveReport",
              "pageName": "Regions",
              "pageIcon": "fa-table",
              "reportImplementation": "TABLE",
              "table": "OEHR_REGIONS",
              "includeFormWithReport": true,
              "help": ""
            }
            ,
            {
              "page": "7",
              "pageType": "interactiveReport",
              "pageName": "Warehouses",
              "pageIcon": "fa-table",
              "reportImplementation": "TABLE",
              "table": "OEHR_WAREHOUSES",
              "includeFormWithReport": true,
              "foreignKeyRelationships": [
                {
                  "foreignKeyColumn": "LOCATION_ID",
                  "detailTable": "OEHR_LOCATIONS",
                  "detailTableKeyColumn": "LOCATION_ID",
                  "detailTableDisplayColumn": "CITY"
                }
              ],
              "help": ""
            }
            ,
            {
              "page": "8",
              "pageType": "interactiveReport",
              "pageName": "Products",
              "pageIcon": "fa-table",
              "reportImplementation": "TABLE",
              "table": "OEHR_PRODUCT_INFORMATION",
              "includeFormWithReport": true,
              "help": ""
            }
            ,
            {
              "page": "9",
              "pageType": "interactiveReport",
              "pageName": "Inventories",
              "pageIcon": "fa-table",
              "reportImplementation": "TABLE",
              "table": "OEHR_INVENTORIES",
              "includeFormWithReport": true,
              "foreignKeyRelationships": [
                {
                  "foreignKeyColumn": "PRODUCT_ID",
                  "detailTable": "OEHR_PRODUCT_INFORMATION",
                  "detailTableKeyColumn": "PRODUCT_ID",
                  "detailTableDisplayColumn": "PRODUCT_NAME"
                }
                ,
                {
                  "foreignKeyColumn": "WAREHOUSE_ID",
                  "detailTable": "OEHR_WAREHOUSES",
                  "detailTableKeyColumn": "WAREHOUSE_ID",
                  "detailTableDisplayColumn": "WAREHOUSE_NAME"
                }
              ],
              "help": ""
            }
            ,
            {
              "page": "10",
              "pageType": "interactiveReport",
              "pageName": "Customers",
              "pageIcon": "fa-table",
              "reportImplementation": "TABLE",
              "table": "OEHR_CUSTOMERS",
              "includeFormWithReport": true,
              "foreignKeyRelationships": [
                {
                  "foreignKeyColumn": "ACCOUNT_MGR_ID",
                  "detailTable": "OEHR_EMPLOYEES",
                  "detailTableKeyColumn": "EMPLOYEE_ID",
                  "detailTableDisplayColumn": "LAST_NAME"
                }
              ],
              "help": ""
            }
            ,
            {
              "page": "11",
              "pageType": "masterDetailForm",
              "pageName": "Orders",
              "pageIcon": "fa-layout-header-sidebar-left",
              "formImplementation": "masterDetailGrid",
              "table": "OEHR_ORDERS",
              "detailTable1": "OEHR_ORDER_ITEMS",
              "help": ""
            }
            ,
            {
              "page": "12",
              "pageType": "calendar",
              "pageName": "Orders Calendar",
              "pageIcon": "fa-calendar-o",
              "table": "OEHR_ORDERS",
              "calendarDisplayColumn": "ORDER_DATE",
              "calendarDateColumnStart": "ORDER_DATE",
              "calendarDateColumnEnd": "",
              "calendarShowTime": "N",
              "help": ""
            }
            ,
            {
              "page": "13",
              "pageType": "interactiveReport",
              "pageName": "Countries",
              "pageIcon": "fa-table",
              "pageIsAdministrative": true,
              "reportImplementation": "TABLE",
              "table": "OEHR_COUNTRIES",
              "includeFormWithReport": true,
              "foreignKeyRelationships": [
                {
                  "foreignKeyColumn": "REGION_ID",
                  "detailTable": "OEHR_REGIONS",
                  "detailTableKeyColumn": "REGION_ID",
                  "detailTableDisplayColumn": "REGION_NAME"
                }
              ],
              "help": ""
            }
            ],
          "generalSettings": {
            "learnAppDefaults": false,
            "version": "Release 1.0",
            "logging": true,
            "debugging": true
            },
          "securitySettings": {
            "deepLinking": false,
            "maximumSessionSeconds": "",
            "maximumSessionIdleSeconds": ""
            }
          }
        }~';

    insert into wwv_sample_json (wwv_sample_dataset_id, language_cd, create_app_wizard_json) 
    values (  3, 'en', l_clob);

    commit;

    -- Insert into DML Table
    delete from wwv_sample_dmls
    where wwv_sample_dataset_id = 3;

   l_clob :=q'~begin
        insert into oehr_regions values ( 1, 'Europe' );
        insert into oehr_regions values ( 2, 'Americas' );
        insert into oehr_regions values ( 3, 'Asia' );
        insert into oehr_regions values ( 4, 'Middle East and Africa' );

        insert into oehr_countries values ( 'IT', 'Italy', 1 );
        insert into oehr_countries values ( 'JP', 'Japan', 3 );
        insert into oehr_countries values ( 'US', 'United States of America', 2 );
        insert into oehr_countries values ( 'CA', 'Canada', 2 );
        insert into oehr_countries values ( 'CN', 'China', 3 );
        insert into oehr_countries values ( 'IN', 'India', 3 );
        insert into oehr_countries values ( 'AU', 'Australia', 3 );
        insert into oehr_countries values ( 'ZW', 'Zimbabwe', 4 );
        insert into oehr_countries values ( 'SG', 'Singapore', 3 );
        insert into oehr_countries values ( 'UK', 'United Kingdom', 1 );
        insert into oehr_countries values ( 'FR', 'France', 1 );
        insert into oehr_countries values ( 'DE', 'Germany', 1 );
        insert into oehr_countries values ( 'ZM', 'Zambia', 4 );
        insert into oehr_countries values ( 'EG', 'Egypt', 4 );
        insert into oehr_countries values ( 'BR', 'Brazil', 2 );
        insert into oehr_countries values ( 'CH', 'Switzerland', 1 );
        insert into oehr_countries values ( 'NL', 'Netherlands', 1 );
        insert into oehr_countries values ( 'MX', 'Mexico', 2 );
        insert into oehr_countries values ( 'KW', 'Kuwait', 4 );
        insert into oehr_countries values ( 'IL', 'Israel', 4 );
        insert into oehr_countries values ( 'DK', 'Denmark', 1 );
        insert into oehr_countries values ( 'HK', 'HongKong', 3 );
        insert into oehr_countries values ( 'NG', 'Nigeria', 4 );
        insert into oehr_countries values ( 'AR', 'Argentina', 2 );
        insert into oehr_countries values ( 'BE', 'Belgium', 1 );

        insert into oehr_locations values ( 1000 , '1297 Via Cola di Rie', '00989', 'Roma', NULL, 'IT' );
        insert into oehr_locations values ( 1100 , '93091 Calle della Testa', '10934', 'Venice', NULL, 'IT' );
        insert into oehr_locations values ( 1200 , '2017 Shinjuku-ku', '1689', 'Tokyo', 'Tokyo Prefecture', 'JP' );
        insert into oehr_locations values ( 1300 , '9450 Kamiya-cho', '6823', 'Hiroshima', NULL, 'JP' );
        insert into oehr_locations values ( 1400 , '2014 Jabberwocky Rd', '26192', 'Southlake', 'Texas', 'US' );
        insert into oehr_locations values ( 1500 , '2011 Interiors Blvd', '99236', 'South San Francisco', 'California', 'US' );
        insert into oehr_locations values ( 1600 , '2007 Zagora St', '50090', 'South Brunswick', 'New Jersey', 'US' );
        insert into oehr_locations values ( 1700 , '2004 Charade Rd', '98199', 'Seattle', 'Washington', 'US' );
        insert into oehr_locations values ( 1800 , '147 Spadina Ave', 'M5V 2L7', 'Toronto', 'Ontario', 'CA' );
        insert into oehr_locations values ( 1900 , '6092 Boxwood St', 'YSW 9T2', 'Whitehorse', 'Yukon', 'CA' );
        insert into oehr_locations values ( 2000 , '40-5-12 Laogianggen', '190518', 'Beijing', NULL, 'CN' );
        insert into oehr_locations values ( 2100 , '1298 Vileparle (E)', '490231', 'Bombay', 'Maharashtra', 'IN' );
        insert into oehr_locations values ( 2200 , '12-98 Victoria Street', '2901', 'Sydney', 'New South Wales', 'AU' );
        insert into oehr_locations values ( 2300 , '198 Clementi North', '540198', 'Singapore', NULL, 'SG' );
        insert into oehr_locations values ( 2400 , '8204 Arthur St', NULL, 'London', NULL, 'UK' );
        insert into oehr_locations values ( 2500 , 'Magdalen Centre, The Oxford Science Park', 'OX9 9ZB', 'Oxford', 'Oxford', 'UK' );
        insert into oehr_locations values ( 2600 , '9702 Chester Road', '09629850293', 'Stretford', 'Manchester', 'UK' );
        insert into oehr_locations values ( 2700 , 'Schwanthalerstr. 7031', '80925', 'Munich', 'Bavaria', 'DE' );
        insert into oehr_locations values ( 2800 , 'Rua Frei Caneca 1360 ', '01307-002', 'Sao Paulo', 'Sao Paulo', 'BR' );
        insert into oehr_locations values ( 2900 , '20 Rue des Corps-Saints', '1730', 'Geneva', 'Geneve', 'CH' );
        insert into oehr_locations values ( 3000 , 'Murtenstrasse 921', '3095', 'Bern', 'BE', 'CH' );
        insert into oehr_locations values ( 3100 , 'Pieter Breughelstraat 837', '3029SK', 'Utrecht', 'Utrecht', 'NL' );
        insert into oehr_locations values ( 3200 , 'Mariano Escobedo 9991', '11932', 'Mexico City', 'Distrito Federal', 'MX' );
      end;~';
   insert into wwv_sample_dmls (wwv_sample_dataset_id, language_cd, dml_name, install_seq, dml) 
   values (  3, 'en', 'Insert Into regions, countries, and locations', 10, l_clob);

   l_clob :=q'~alter table oehr_departments disable constraint oehr_dept_mgr_fk~';
   insert into wwv_sample_dmls (wwv_sample_dataset_id, language_cd, dml_name, install_seq, dml) 
   values (  3, 'en', 'Disable departments constraint', 11, l_clob);

   l_clob :=q'~begin
        insert into oehr_departments values ( 10, 'Administration', 200, 1700 );
        insert into oehr_departments values ( 20, 'Marketing', 201, 1800 );
        insert into oehr_departments values ( 30, 'Purchasing', 114, 1700 );
        insert into oehr_departments values ( 40, 'Human Resources', 203, 2400 );
        insert into oehr_departments values ( 50, 'Shipping', 121, 1500 );
        insert into oehr_departments values ( 60 , 'IT', 103, 1400 );                
        insert into oehr_departments values ( 70 , 'Public Relations', 204, 2700 );
        insert into oehr_departments values ( 80 , 'Sales', 145, 2500 );
        insert into oehr_departments values ( 90 , 'Executive', 100, 1700 );
        insert into oehr_departments values ( 100 , 'Finance', 108, 1700 );
        insert into oehr_departments values ( 110 , 'Accounting', 205, 1700 );
        insert into oehr_departments values ( 120 , 'Treasury', NULL, 1700 );
        insert into oehr_departments values ( 130 , 'Corporate Tax', NULL, 1700 );
        insert into oehr_departments values ( 140 , 'Control And Credit', NULL, 1700 );
        insert into oehr_departments values ( 150 , 'Shareholder Services', NULL, 1700 );
        insert into oehr_departments values ( 160 , 'Benefits', NULL, 1700 );
        insert into oehr_departments values ( 170 , 'Manufacturing', NULL, 1700 );
        insert into oehr_departments values ( 180 , 'Construction', NULL, 1700 );
        insert into oehr_departments values ( 190 , 'Contracting', NULL, 1700 );
        insert into oehr_departments values ( 200 , 'Operations', NULL, 1700 );
        insert into oehr_departments values ( 210 , 'IT Support', NULL, 1700 );
        insert into oehr_departments values ( 220 , 'NOC', NULL, 1700 );
        insert into oehr_departments values ( 230 , 'IT Helpdesk', NULL, 1700 );
        insert into oehr_departments values ( 240 , 'Government Sales', NULL, 1700 );
        insert into oehr_departments values ( 250 , 'Retail Sales', NULL, 1700 );
        insert into oehr_departments values ( 260 , 'Recruiting', NULL, 1700 );
        insert into oehr_departments values ( 270 , 'Payroll', NULL, 1700 );

        insert into oehr_jobs values ( 'AD_PRES', 'President', 20000, 40000 );
        insert into oehr_jobs values ( 'AD_VP', 'Administration Vice President', 15000, 30000 );
        insert into oehr_jobs values ( 'AD_ASST', 'Administration Assistant', 3000, 6000 );
        insert into oehr_jobs values ( 'FI_MGR', 'Finance Manager', 8200, 16000 );
        insert into oehr_jobs values ( 'FI_ACCOUNT', 'Accountant', 4200, 9000 );
        insert into oehr_jobs values ( 'AC_MGR', 'Accounting Manager', 8200, 16000 );
        insert into oehr_jobs values ( 'AC_ACCOUNT', 'Public Accountant', 4200, 9000 );
        insert into oehr_jobs values ( 'SA_MAN', 'Sales Manager', 10000, 20000 );
        insert into oehr_jobs values ( 'SA_REP', 'Sales Representative', 6000, 12000 );
        insert into oehr_jobs values ( 'PU_MAN', 'Purchasing Manager', 8000, 15000 );
        insert into oehr_jobs values ( 'PU_CLERK', 'Purchasing Clerk', 2500, 5500 );
        insert into oehr_jobs values ( 'ST_MAN', 'Stock Manager', 5500, 8500 );
        insert into oehr_jobs values ( 'ST_CLERK', 'Stock Clerk', 2000, 5000 );
        insert into oehr_jobs values ( 'SH_CLERK', 'Shipping Clerk', 2500, 5500 );
        insert into oehr_jobs values ( 'IT_PROG', 'Programmer', 4000, 10000 );
        insert into oehr_jobs values ( 'MK_MAN', 'Marketing Manager', 9000, 15000 );
        insert into oehr_jobs values ( 'MK_REP', 'Marketing Representative', 4000, 9000 );
        insert into oehr_jobs values ( 'HR_REP', 'Human Resources Representative', 4000, 9000 );
        insert into oehr_jobs values ( 'PR_REP', 'Public Relations Representative', 4500, 10500 );

        insert into oehr_employees values ( 100, 'Steven', 'King', 'SKING', '515.123.4567', TO_DATE('17-06-1987', 'dd-mm-yyyy'), 'AD_PRES', 24000, NULL, NULL, 90 );
        insert into oehr_employees values ( 101, 'Neena', 'Kochhar', 'NKOCHHAR', '515.123.4568', TO_DATE('21-09-1989', 'dd-mm-yyyy'), 'AD_VP', 17000, NULL, 100, 90 );
        insert into oehr_employees values ( 102, 'Lex', 'De Haan', 'LDEHAAN', '515.123.4569', TO_DATE('13-01-1993', 'dd-mm-yyyy'), 'AD_VP', 17000, NULL, 100, 90 );
        insert into oehr_employees values ( 103, 'Alexander', 'Hunold', 'AHUNOLD', '590.423.4567', TO_DATE('03-01-1990', 'dd-mm-yyyy'), 'IT_PROG', 9000, NULL, 102, 60 );
        insert into oehr_employees values ( 104, 'Bruce', 'Ernst', 'BERNST', '590.423.4568', TO_DATE('21-05-1991', 'dd-mm-yyyy'), 'IT_PROG', 6000, NULL, 103, 60 );
        insert into oehr_employees values ( 105, 'David', 'Austin', 'DAUSTIN', '590.423.4569', TO_DATE('25-06-1997', 'dd-mm-yyyy'), 'IT_PROG', 4800, NULL, 103, 60 );
        insert into oehr_employees values ( 106, 'Valli', 'Pataballa', 'VPATABAL', '590.423.4560', TO_DATE('05-02-1998', 'dd-mm-yyyy'), 'IT_PROG', 4800, NULL, 103, 60 );
        insert into oehr_employees values ( 107, 'Diana', 'Lorentz', 'DLORENTZ', '590.423.5567', TO_DATE('07-02-1999', 'dd-mm-yyyy'), 'IT_PROG', 4200, NULL, 103, 60 );
        insert into oehr_employees values ( 108, 'Nancy', 'Greenberg', 'NGREENBE', '515.124.4569', TO_DATE('17-08-1994', 'dd-mm-yyyy'), 'FI_MGR', 12000, NULL, 101, 100 );
        insert into oehr_employees values ( 109, 'Daniel', 'Faviet', 'DFAVIET', '515.124.4169', TO_DATE('16-08-1994', 'dd-mm-yyyy'), 'FI_ACCOUNT', 9000, NULL, 108, 100 );
        insert into oehr_employees values ( 110, 'John', 'Chen', 'JCHEN', '515.124.4269', TO_DATE('28-09-1997', 'dd-mm-yyyy'), 'FI_ACCOUNT', 8200, NULL, 108, 100 );
        insert into oehr_employees values ( 111, 'Ismael', 'Sciarra', 'ISCIARRA', '515.124.4369', TO_DATE('30-09-1997', 'dd-mm-yyyy'), 'FI_ACCOUNT', 7700, NULL, 108, 100 );
        insert into oehr_employees values ( 112, 'Jose Manuel', 'Urman', 'JMURMAN', '515.124.4469', TO_DATE('07-03-1998', 'dd-mm-yyyy'), 'FI_ACCOUNT', 7800, NULL, 108, 100 );
        insert into oehr_employees values ( 113, 'Luis', 'Popp', 'LPOPP', '515.124.4567', TO_DATE('07-12-1999', 'dd-mm-yyyy'), 'FI_ACCOUNT', 6900, NULL, 108, 100 );
        insert into oehr_employees values ( 114, 'Den', 'Raphaely', 'DRAPHEAL', '515.127.4561', TO_DATE('07-12-1994', 'dd-mm-yyyy'), 'PU_MAN', 11000, NULL, 100, 30 );
        insert into oehr_employees values ( 115, 'Alexander', 'Khoo', 'AKHOO', '515.127.4562', TO_DATE('18-05-1995', 'dd-mm-yyyy'), 'PU_CLERK', 3100, NULL, 114, 30 );
        insert into oehr_employees values ( 116, 'Shelli', 'Baida', 'SBAIDA', '515.127.4563', TO_DATE('24-12-1997', 'dd-mm-yyyy'), 'PU_CLERK', 2900, NULL, 114, 30 );
        insert into oehr_employees values ( 117, 'Sigal', 'Tobias', 'STOBIAS', '515.127.4564', TO_DATE('24-07-1997', 'dd-mm-yyyy'), 'PU_CLERK', 2800, NULL, 114, 30 );
        insert into oehr_employees values ( 118, 'Guy', 'Himuro', 'GHIMURO', '515.127.4565', TO_DATE('15-11-1998', 'dd-mm-yyyy'), 'PU_CLERK', 2600, NULL, 114, 30 );
        insert into oehr_employees values ( 119, 'Karen', 'Colmenares', 'KCOLMENA', '515.127.4566', TO_DATE('10-08-1999', 'dd-mm-yyyy'), 'PU_CLERK', 2500, NULL, 114, 30 );
        insert into oehr_employees values ( 120, 'Matthew', 'Weiss', 'MWEISS', '650.123.1234', TO_DATE('18-07-1996', 'dd-mm-yyyy'), 'ST_MAN', 8000, NULL, 100, 50 );
        insert into oehr_employees values ( 121, 'Adam', 'Fripp', 'AFRIPP', '650.123.2234', TO_DATE('10-04-1997', 'dd-mm-yyyy'), 'ST_MAN', 8200, NULL, 100, 50 );
        insert into oehr_employees values ( 122, 'Payam', 'Kaufling', 'PKAUFLIN', '650.123.3234', TO_DATE('01-05-1995', 'dd-mm-yyyy'), 'ST_MAN', 7900, NULL, 100, 50 );
        insert into oehr_employees values ( 123, 'Shanta', 'Vollman', 'SVOLLMAN', '650.123.4234', TO_DATE('10-10-1997', 'dd-mm-yyyy'), 'ST_MAN', 6500, NULL, 100, 50 );
        insert into oehr_employees values ( 124, 'Kevin', 'Mourgos', 'KMOURGOS', '650.123.5234', TO_DATE('16-11-1999', 'dd-mm-yyyy'), 'ST_MAN', 5800, NULL, 100, 50 );
        insert into oehr_employees values ( 125, 'Julia', 'Nayer', 'JNAYER', '650.124.1214', TO_DATE('16-07-1997', 'dd-mm-yyyy'), 'ST_CLERK', 3200, NULL, 120, 50 );
        insert into oehr_employees values ( 126, 'Irene', 'Mikkilineni', 'IMIKKILI', '650.124.1224', TO_DATE('28-09-1998', 'dd-mm-yyyy'), 'ST_CLERK', 2700, NULL, 120, 50 );
        insert into oehr_employees values ( 127, 'James', 'Landry', 'JLANDRY', '650.124.1334', TO_DATE('14-01-1999', 'dd-mm-yyyy'), 'ST_CLERK', 2400, NULL, 120, 50 );
        insert into oehr_employees values ( 128, 'Steven', 'Markle', 'SMARKLE', '650.124.1434', TO_DATE('08-03-2000', 'dd-mm-yyyy'), 'ST_CLERK', 2200, NULL, 120, 50 );
        insert into oehr_employees values ( 129, 'Laura', 'Bissot', 'LBISSOT', '650.124.5234', TO_DATE('20-08-1997', 'dd-mm-yyyy'), 'ST_CLERK', 3300, NULL, 121, 50 );
        insert into oehr_employees values ( 130, 'Mozhe', 'Atkinson', 'MATKINSO', '650.124.6234', TO_DATE('30-10-1997', 'dd-mm-yyyy'), 'ST_CLERK', 2800, NULL, 121, 50 );
        insert into oehr_employees values ( 131, 'James', 'Marlow', 'JAMRLOW', '650.124.7234', TO_DATE('16-02-1997', 'dd-mm-yyyy'), 'ST_CLERK', 2500, NULL, 121, 50 );
        insert into oehr_employees values ( 132, 'TJ', 'Olson', 'TJOLSON', '650.124.8234', TO_DATE('10-04-1999', 'dd-mm-yyyy'), 'ST_CLERK', 2100, NULL, 121, 50 );
        insert into oehr_employees values ( 133, 'Jason', 'Mallin', 'JMALLIN', '650.127.1934', TO_DATE('14-06-1996', 'dd-mm-yyyy'), 'ST_CLERK', 3300, NULL, 122, 50 );
        insert into oehr_employees values ( 134, 'Michael', 'Rogers', 'MROGERS', '650.127.1834', TO_DATE('26-08-1998', 'dd-mm-yyyy'), 'ST_CLERK', 2900, NULL, 122, 50 );
        insert into oehr_employees values ( 135, 'Ki', 'Gee', 'KGEE', '650.127.1734', TO_DATE('12-12-1999', 'dd-mm-yyyy'), 'ST_CLERK', 2400, NULL, 122, 50 );
        insert into oehr_employees values ( 136, 'Hazel', 'Philtanker', 'HPHILTAN', '650.127.1634', TO_DATE('06-02-2000', 'dd-mm-yyyy'), 'ST_CLERK', 2200, NULL, 122, 50 );
        insert into oehr_employees values ( 137, 'Renske', 'Ladwig', 'RLADWIG', '650.121.1234', TO_DATE('14-07-1995', 'dd-mm-yyyy'), 'ST_CLERK', 3600, NULL, 123, 50 );
        insert into oehr_employees values ( 138, 'Stephen', 'Stiles', 'SSTILES', '650.121.2034', TO_DATE('26-10-1997', 'dd-mm-yyyy'), 'ST_CLERK', 3200, NULL, 123, 50 );
        insert into oehr_employees values ( 139, 'John', 'Seo', 'JSEO', '650.121.2019', TO_DATE('12-02-1998', 'dd-mm-yyyy'), 'ST_CLERK', 2700, NULL, 123, 50 );
        insert into oehr_employees values ( 140, 'Joshua', 'Patel', 'JPATEL', '650.121.1834', TO_DATE('06-04-1998', 'dd-mm-yyyy'), 'ST_CLERK', 2500, NULL, 123, 50 );
        insert into oehr_employees values ( 141, 'Trenna', 'Rajs', 'TRAJS', '650.121.8009', TO_DATE('17-10-1995', 'dd-mm-yyyy'), 'ST_CLERK', 3500, NULL, 124, 50 );
        insert into oehr_employees values ( 142, 'Curtis', 'Davies', 'CDAVIES', '650.121.2994', TO_DATE('29-01-1997', 'dd-mm-yyyy'), 'ST_CLERK', 3100, NULL, 124, 50 );
        insert into oehr_employees values ( 143, 'Randall', 'Matos', 'RMATOS', '650.121.2874', TO_DATE('15-03-1998', 'dd-mm-yyyy'), 'ST_CLERK', 2600, NULL, 124, 50 );
        insert into oehr_employees values ( 144, 'Peter', 'Vargas', 'PVARGAS', '650.121.2004', TO_DATE('09-07-1998', 'dd-mm-yyyy'), 'ST_CLERK', 2500, NULL, 124, 50 );
        insert into oehr_employees values ( 145, 'John', 'Russell', 'JRUSSEL', '011.44.1344.429268', TO_DATE('01-10-1996', 'dd-mm-yyyy'), 'SA_MAN', 14000, .4, 100, 80 );
        insert into oehr_employees values ( 146, 'Karen', 'Partners', 'KPARTNER', '011.44.1344.467268', TO_DATE('05-01-1997', 'dd-mm-yyyy'), 'SA_MAN', 13500, .3, 100, 80 );
        insert into oehr_employees values ( 147, 'Alberto', 'Errazuriz', 'AERRAZUR', '011.44.1344.429278', TO_DATE('10-03-1997', 'dd-mm-yyyy'), 'SA_MAN', 12000, .3, 100, 80 );
        insert into oehr_employees values ( 148, 'Gerald', 'Cambrault', 'GCAMBRAU', '011.44.1344.619268', TO_DATE('15-10-1999', 'dd-mm-yyyy'), 'SA_MAN', 11000, .3, 100, 80 );
        insert into oehr_employees values ( 149, 'Eleni', 'Zlotkey', 'EZLOTKEY', '011.44.1344.429018', TO_DATE('29-01-2000', 'dd-mm-yyyy'), 'SA_MAN', 10500, .2, 100, 80 );
        insert into oehr_employees values ( 150, 'Peter', 'Tucker', 'PTUCKER', '011.44.1344.129268', TO_DATE('30-01-1997', 'dd-mm-yyyy'), 'SA_REP', 10000, .3, 145, 80 );
        insert into oehr_employees values ( 151, 'David', 'Bernstein', 'DBERNSTE', '011.44.1344.345268', TO_DATE('24-03-1997', 'dd-mm-yyyy'), 'SA_REP', 9500, .25, 145, 80 );
        insert into oehr_employees values ( 152, 'Peter', 'Hall', 'PHALL', '011.44.1344.478968', TO_DATE('20-08-1997', 'dd-mm-yyyy'), 'SA_REP', 9000, .25, 145, 80 );
        insert into oehr_employees values ( 153, 'Christopher', 'Olsen', 'COLSEN', '011.44.1344.498718', TO_DATE('30-03-1998', 'dd-mm-yyyy'), 'SA_REP', 8000, .2, 145, 80 );
        insert into oehr_employees values ( 154, 'Nanette', 'Cambrault', 'NCAMBRAU', '011.44.1344.987668', TO_DATE('09-12-1998', 'dd-mm-yyyy'), 'SA_REP', 7500, .2, 145, 80 );
        insert into oehr_employees values ( 155, 'Oliver', 'Tuvault', 'OTUVAULT', '011.44.1344.486508', TO_DATE('23-11-1999', 'dd-mm-yyyy'), 'SA_REP', 7000, .15, 145, 80 );
        insert into oehr_employees values ( 156, 'Janette', 'King', 'JKING', '011.44.1345.429268', TO_DATE('30-01-1996', 'dd-mm-yyyy'), 'SA_REP', 10000, .35, 146, 80 );
        insert into oehr_employees values ( 157, 'Patrick', 'Sully', 'PSULLY', '011.44.1345.929268', TO_DATE('04-03-1996', 'dd-mm-yyyy'), 'SA_REP', 9500, .35, 146, 80 );
        insert into oehr_employees values ( 158, 'Allan', 'McEwen', 'AMCEWEN', '011.44.1345.829268', TO_DATE('01-08-1996', 'dd-mm-yyyy'), 'SA_REP', 9000, .35, 146, 80 );
        insert into oehr_employees values ( 159, 'Lindsey', 'Smith', 'LSMITH', '011.44.1345.729268', TO_DATE('10-03-1997', 'dd-mm-yyyy'), 'SA_REP', 8000, .3, 146, 80 );
        insert into oehr_employees values ( 160, 'Louise', 'Doran', 'LDORAN', '011.44.1345.629268', TO_DATE('15-12-1997', 'dd-mm-yyyy'), 'SA_REP', 7500, .3, 146, 80 );
        insert into oehr_employees values ( 161, 'Sarath', 'Sewall', 'SSEWALL', '011.44.1345.529268', TO_DATE('03-11-1998', 'dd-mm-yyyy'), 'SA_REP', 7000, .25, 146, 80 );
        insert into oehr_employees values ( 162, 'Clara', 'Vishney', 'CVISHNEY', '011.44.1346.129268', TO_DATE('11-11-1997', 'dd-mm-yyyy'), 'SA_REP', 10500, .25, 147, 80 );
        insert into oehr_employees values ( 163, 'Danielle', 'Greene', 'DGREENE', '011.44.1346.229268', TO_DATE('19-03-1999', 'dd-mm-yyyy'), 'SA_REP', 9500, .15, 147, 80 );
        insert into oehr_employees values ( 164, 'Mattea', 'Marvins', 'MMARVINS', '011.44.1346.329268', TO_DATE('24-01-2000', 'dd-mm-yyyy'), 'SA_REP', 7200, .10, 147, 80 );
        insert into oehr_employees values ( 165, 'David', 'Lee', 'DLEE', '011.44.1346.529268', TO_DATE('23-02-2000', 'dd-mm-yyyy'), 'SA_REP', 6800, .1, 147, 80 );
        insert into oehr_employees values ( 166, 'Sundar', 'Ande', 'SANDE', '011.44.1346.629268', TO_DATE('24-03-2000', 'dd-mm-yyyy'), 'SA_REP', 6400, .10, 147, 80 );
        insert into oehr_employees values ( 167, 'Amit', 'Banda', 'ABANDA', '011.44.1346.729268', TO_DATE('21-04-2000', 'dd-mm-yyyy'), 'SA_REP', 6200, .10, 147, 80 );
        insert into oehr_employees values ( 168, 'Lisa', 'Ozer', 'LOZER', '011.44.1343.929268', TO_DATE('11-03-1997', 'dd-mm-yyyy'), 'SA_REP', 11500, .25, 148, 80 );
        insert into oehr_employees values ( 169  , 'Harrison', 'Bloom', 'HBLOOM', '011.44.1343.829268', TO_DATE('23-03-1998', 'dd-mm-yyyy'), 'SA_REP', 10000, .20, 148, 80 );
        insert into oehr_employees values ( 170, 'Tayler', 'Fox', 'TFOX', '011.44.1343.729268', TO_DATE('24-01-1998', 'dd-mm-yyyy'), 'SA_REP', 9600, .20, 148, 80 );
        insert into oehr_employees values ( 171, 'William', 'Smith', 'WSMITH', '011.44.1343.629268', TO_DATE('23-02-1999', 'dd-mm-yyyy'), 'SA_REP', 7400, .15, 148, 80 );
        insert into oehr_employees values ( 172, 'Elizabeth', 'Bates', 'EBATES', '011.44.1343.529268', TO_DATE('24-03-1999', 'dd-mm-yyyy'), 'SA_REP', 7300, .15, 148, 80 );
        insert into oehr_employees values ( 173, 'Sundita', 'Kumar', 'SKUMAR', '011.44.1343.329268', TO_DATE('21-04-2000', 'dd-mm-yyyy'), 'SA_REP', 6100, .10, 148, 80 );
        insert into oehr_employees values ( 174, 'Ellen', 'Abel', 'EABEL', '011.44.1644.429267', TO_DATE('11-05-1996', 'dd-mm-yyyy'), 'SA_REP', 11000, .30, 149, 80 );
        insert into oehr_employees values ( 175, 'Alyssa', 'Hutton', 'AHUTTON', '011.44.1644.429266', TO_DATE('19-03-1997', 'dd-mm-yyyy'), 'SA_REP', 8800, .25, 149, 80 );
        insert into oehr_employees values ( 176, 'Jonathon', 'Taylor', 'JTAYLOR', '011.44.1644.429265', TO_DATE('24-03-1998', 'dd-mm-yyyy'), 'SA_REP', 8600, .20, 149, 80 );
        insert into oehr_employees values ( 177, 'Jack', 'Livingston', 'JLIVINGS', '011.44.1644.429264', TO_DATE('23-04-1998', 'dd-mm-yyyy'), 'SA_REP', 8400, .20, 149, 80 );
        insert into oehr_employees values ( 178, 'Kimberely', 'Grant', 'KGRANT', '011.44.1644.429263', TO_DATE('24-05-1999', 'dd-mm-yyyy'), 'SA_REP', 7000, .15, 149, NULL );
        insert into oehr_employees values ( 179, 'Charles', 'Johnson', 'CJOHNSON', '011.44.1644.429262', TO_DATE('04-01-2000', 'dd-mm-yyyy'), 'SA_REP', 6200, .10, 149, 80 );
        insert into oehr_employees values ( 180, 'Winston', 'Taylor', 'WTAYLOR', '650.507.9876', TO_DATE('24-01-1998', 'dd-mm-yyyy'), 'SH_CLERK', 3200, NULL, 120, 50 );
        insert into oehr_employees values ( 181, 'Jean', 'Fleaur', 'JFLEAUR', '650.507.9877', TO_DATE('23-02-1998', 'dd-mm-yyyy'), 'SH_CLERK', 3100, NULL, 120, 50 );
        insert into oehr_employees values ( 182, 'Martha', 'Sullivan', 'MSULLIVA', '650.507.9878', TO_DATE('21-06-1999', 'dd-mm-yyyy'), 'SH_CLERK', 2500, NULL, 120, 50 );
        insert into oehr_employees values ( 183, 'Girard', 'Geoni', 'GGEONI', '650.507.9879', TO_DATE('03-02-2000', 'dd-mm-yyyy'), 'SH_CLERK', 2800, NULL, 120, 50 );
        insert into oehr_employees values ( 184, 'Nandita', 'Sarchand', 'NSARCHAN', '650.509.1876', TO_DATE('27-01-1996', 'dd-mm-yyyy'), 'SH_CLERK', 4200, NULL, 121, 50 );
        insert into oehr_employees values ( 185, 'Alexis', 'Bull', 'ABULL', '650.509.2876', TO_DATE('20-02-1997', 'dd-mm-yyyy'), 'SH_CLERK', 4100, NULL, 121, 50 );
        insert into oehr_employees values ( 186, 'Julia', 'Dellinger', 'JDELLING', '650.509.3876', TO_DATE('24-06-1998', 'dd-mm-yyyy'), 'SH_CLERK', 3400, NULL, 121, 50 );
        insert into oehr_employees values ( 187, 'Anthony', 'Cabrio', 'ACABRIO', '650.509.4876', TO_DATE('07-02-1999', 'dd-mm-yyyy'), 'SH_CLERK', 3000, NULL, 121, 50 );
        insert into oehr_employees values ( 188, 'Kelly', 'Chung', 'KCHUNG', '650.505.1876', TO_DATE('14-06-1997', 'dd-mm-yyyy'), 'SH_CLERK', 3800, NULL, 122, 50 );
        insert into oehr_employees values ( 189, 'Jennifer', 'Dilly', 'JDILLY', '650.505.2876', TO_DATE('13-08-1997', 'dd-mm-yyyy'), 'SH_CLERK', 3600, NULL, 122, 50 );
        insert into oehr_employees values ( 190, 'Timothy', 'Gates', 'TGATES', '650.505.3876', TO_DATE('11-07-1998', 'dd-mm-yyyy'), 'SH_CLERK', 2900, NULL, 122, 50 );
        insert into oehr_employees values ( 191, 'Randall', 'Perkins', 'RPERKINS', '650.505.4876', TO_DATE('19-12-1999', 'dd-mm-yyyy'), 'SH_CLERK', 2500, NULL, 122, 50 );
        insert into oehr_employees values ( 192, 'Sarah', 'Bell', 'SBELL', '650.501.1876', TO_DATE('04-02-1996', 'dd-mm-yyyy'), 'SH_CLERK', 4000, NULL, 123, 50 );
        insert into oehr_employees values ( 193, 'Britney', 'Everett', 'BEVERETT', '650.501.2876', TO_DATE('03-03-1997', 'dd-mm-yyyy'), 'SH_CLERK', 3900, NULL, 123, 50 );
        insert into oehr_employees values ( 194, 'Samuel', 'McCain', 'SMCCAIN', '650.501.3876', TO_DATE('01-07-1998', 'dd-mm-yyyy'), 'SH_CLERK', 3200, NULL, 123, 50 );
        insert into oehr_employees values ( 195, 'Vance', 'Jones', 'VJONES', '650.501.4876', TO_DATE('17-03-1999', 'dd-mm-yyyy'), 'SH_CLERK', 2800, NULL, 123, 50 );
        insert into oehr_employees values ( 196, 'Alana', 'Walsh', 'AWALSH', '650.507.9811', TO_DATE('24-04-1998', 'dd-mm-yyyy'), 'SH_CLERK', 3100, NULL, 124, 50 );
        insert into oehr_employees values ( 197, 'Kevin', 'Feeney', 'KFEENEY', '650.507.9822', TO_DATE('23-05-1998', 'dd-mm-yyyy'), 'SH_CLERK', 3000, NULL, 124, 50 );
        insert into oehr_employees values ( 198, 'Donald', 'OConnell', 'DOCONNEL', '650.507.9833', TO_DATE('21-06-1999', 'dd-mm-yyyy'), 'SH_CLERK', 2600, NULL, 124, 50 );
        insert into oehr_employees values ( 199, 'Douglas', 'Grant', 'DGRANT', '650.507.9844', TO_DATE('13-01-2000', 'dd-mm-yyyy'), 'SH_CLERK', 2600, NULL, 124, 50 );
        insert into oehr_employees values ( 200, 'Jennifer', 'Whalen', 'JWHALEN', '515.123.4444', TO_DATE('17-09-1987', 'dd-mm-yyyy'), 'AD_ASST', 4400, NULL, 101, 10 );
        insert into oehr_employees values ( 201, 'Michael', 'Hartstein', 'MHARTSTE', '515.123.5555', TO_DATE('17-02-1996', 'dd-mm-yyyy'), 'MK_MAN', 13000, NULL, 100, 20 );
        insert into oehr_employees values ( 202, 'Pat', 'Fay', 'PFAY', '603.123.6666', TO_DATE('17-08-1997', 'dd-mm-yyyy'), 'MK_REP', 6000, NULL, 201, 20 );
        insert into oehr_employees values ( 203, 'Susan', 'Mavris', 'SMAVRIS', '515.123.7777', TO_DATE('07-06-1994', 'dd-mm-yyyy'), 'HR_REP', 6500, NULL, 101, 40 );
        insert into oehr_employees values ( 204, 'Hermann', 'Baer', 'HBAER', '515.123.8888', TO_DATE('07-06-1994', 'dd-mm-yyyy'), 'PR_REP', 10000, NULL, 101, 70 );
        insert into oehr_employees values ( 205, 'Shelley', 'Higgins', 'SHIGGINS', '515.123.8080', TO_DATE('07-06-1994', 'dd-mm-yyyy'), 'AC_MGR', 12000, NULL, 101, 110 );
        insert into oehr_employees values ( 206, 'William', 'Gietz', 'WGIETZ', '515.123.8181', TO_DATE('07-06-1994', 'dd-mm-yyyy'), 'AC_ACCOUNT', 8300, NULL, 205, 110 );
      end;~';
   insert into wwv_sample_dmls (wwv_sample_dataset_id, language_cd, dml_name, install_seq, dml) 
   values (  3, 'en', 'Insert Into departments, jobs, and employees', 12, l_clob);

   l_clob :=q'~alter table oehr_departments enable constraint oehr_dept_mgr_fk~';
   insert into wwv_sample_dmls (wwv_sample_dataset_id, language_cd, dml_name, install_seq, dml) 
   values (  3, 'en', 'Enable departments constraint', 13, l_clob);

   l_clob :=q'~begin
        insert into oehr_job_history values (102, TO_DATE('13-01-1993', 'dd-mm-yyyy'), TO_DATE('24-07-1998', 'dd-mm-yyyy'), 'IT_PROG', 60);
        insert into oehr_job_history values (101, TO_DATE('21-09-1989', 'dd-mm-yyyy'), TO_DATE('27-10-1993', 'dd-mm-yyyy'), 'AC_ACCOUNT', 110);
        insert into oehr_job_history values (101, TO_DATE('28-10-1993', 'dd-mm-yyyy'), TO_DATE('15-03-1997', 'dd-mm-yyyy'), 'AC_MGR', 110);
        insert into oehr_job_history values (201, TO_DATE('17-02-1996', 'dd-mm-yyyy'), TO_DATE('19-12-1999', 'dd-mm-yyyy'), 'MK_REP', 20);
        insert into oehr_job_history values (114, TO_DATE('24-03-1998', 'dd-mm-yyyy'), TO_DATE('31-12-1999', 'dd-mm-yyyy'), 'ST_CLERK', 50 );
        insert into oehr_job_history values (122, TO_DATE('01-01-1999', 'dd-mm-yyyy'), TO_DATE('31-12-1999', 'dd-mm-yyyy'), 'ST_CLERK', 50 );
        insert into oehr_job_history values (200, TO_DATE('17-09-1987', 'dd-mm-yyyy'), TO_DATE('17-06-1993', 'dd-mm-yyyy'), 'AD_ASST', 90 );
        insert into oehr_job_history values (176, TO_DATE('24-03-1998', 'dd-mm-yyyy'), TO_DATE('31-12-1998', 'dd-mm-yyyy'), 'SA_REP', 80 );
        insert into oehr_job_history values (176, TO_DATE('01-01-1999', 'dd-mm-yyyy'), TO_DATE('31-12-1999', 'dd-mm-yyyy'), 'SA_MAN', 80 );
        insert into oehr_job_history values (200, TO_DATE('01-07-1994', 'dd-mm-yyyy'), TO_DATE('31-12-1998', 'dd-mm-yyyy'), 'AC_ACCOUNT', 90 );
      end;~';
   insert into wwv_sample_dmls (wwv_sample_dataset_id, language_cd, dml_name, install_seq, dml) 
   values (  3, 'en', 'Insert Into job history', 14, l_clob);

   l_clob :=q'~begin
        insert into oehr_warehouses values (1,'Southlake, Texas',1400); 
        insert into oehr_warehouses values (2,'San Francisco',1500); 
        insert into oehr_warehouses values (3,'New Jersey',1600); 
        insert into oehr_warehouses values (4,'Seattle, Washington',1700); 
        insert into oehr_warehouses values (5,'Toronto',1800);
        insert into oehr_warehouses values (6,'Sydney',2200);
        insert into oehr_warehouses values (7,'Mexico City',3200);
        insert into oehr_warehouses values (8,'Beijing',2000);
        insert into oehr_warehouses values (9,'Bombay',2100);
        insert into oehr_customers values (101,'Constantin','Welles','514 W Superior St','46901','Kokomo','IN','US','+1 317 123 4104','us','AMERICA','100','Constantin.Welles@ANHINGA.COM',149);
        insert into oehr_customers values (102,'Harrison','Pacino','2515 Bloyd Ave','46218','Indianapolis','IN','US','+1 317 123 4111','us','AMERICA','100','Harrison.Pacino@ANI.COM',149);
        insert into oehr_customers values (103,'Manisha','Taylor','8768 N State Rd 37','47404','Bloomington','IN','US','+1 812 123 4115','us','AMERICA','100','Manisha.Taylor@AUKLET.COM',149);
        insert into oehr_customers values (104,'Harrison','Sutherland','6445 Bay Harbor Ln','46254','Indianapolis','IN','US','+1 317 123 4126','us','AMERICA','100','Harrison.Sutherland@GODWIT.COM', 149);
        insert into oehr_customers values (105,'Matthias','MacGraw','4019 W 3Rd St','47404','Bloomington','IN','US','+1 812 123 4129','us','AMERICA','100','Matthias.MacGraw@GOLDENEYE.COM',NULL);
        insert into oehr_customers values (106,'Matthias','Hannah','1608 Portage Ave','46616','South Bend','IN','US','+1 219 123 4136','us','AMERICA','100','Matthias.Hannah@GREBE.COM',149);
        insert into oehr_customers values (107,'Matthias','Cruise','23943 Us Highway 33','46517','Elkhart','IN','US','+1 219 123 4138','us','AMERICA','100','Matthias.Cruise@GROSBEAK.COM',NULL);
        insert into oehr_customers values (108,'Meenakshi','Mason','136 E Market St # 800','46204','Indianapolis','IN','US','+1 317 123 4141','us','AMERICA','100','Meenakshi.Mason@JACANA.COM',149);
        insert into oehr_customers values (109,'Christian','Cage','1905 College St','46628','South Bend','IN','US','+1 219 123 4142','us','AMERICA','100','Christian.Cage@KINGLET.COM',149);
        insert into oehr_customers values (110,'Charlie','Sutherland','3512 Rockville Rd # 137C','46222','Indianapolis','IN','US','+1 317 123 4146','us','AMERICA','200','Charlie.Sutherland@LIMPKIN.COM',149);
        insert into oehr_customers values (111,'Charlie','Pacino','1303 E University St','47401','Bloomington','IN','US','+1 812 123 4150','us','AMERICA','200','Charlie.Pacino@LONGSPUR.COM',149);
        insert into oehr_customers values (112,'Guillaume','Jackson','115 N Weinbach Ave','47711','Evansville','IN','US','+1 812 123 4151','us','AMERICA','200','Guillaume.Jackson@MOORHEN.COM',145);
        insert into oehr_customers values (113,'Daniel','Costner','2067 Rollett Ln','47712','Evansville','IN','US','+1 812 123 4153','us','AMERICA','200','Daniel.Costner@PARULA.COM',149);
        insert into oehr_customers values (114,'Dianne','Derek','1105 E Allendale Dr','47401','Bloomington','IN','US','+1 812 123 4157','us','AMERICA','200','Dianne.Derek@SAW-WHET.COM',149);
        insert into oehr_customers values (115,'Geraldine','Schneider','18305 Van Dyke St','48234','Detroit','MI','US','+1 313 123 4159','us','AMERICA','200','Geraldine.Schneider@SCAUP.COM',149);
        insert into oehr_customers values (116,'Geraldine','Martin','Lucas Dr Bldg 348','48242','Detroit','MI','US','+1 313 123 4160','us','AMERICA','200','Geraldine.Martin@SCOTER.COM',149);
        insert into oehr_customers values (117,'Guillaume','Edwards','1801 Monroe Ave Nw','49505','Grand Rapids','MI','US','+1 616 123 4162','us','AMERICA','200','Guillaume.Edwards@SHRIKE.COM',145);
        insert into oehr_customers values (118,'Maurice','Mahoney','4925 Kendrick St Se','49512','Grand Rapids','MI','US','+1 616 123 4181','us','AMERICA','200','Maurice.Mahoney@SNIPE.COM',149);
        insert into oehr_customers values (119,'Maurice','Hasan','3310 Dixie Ct','48601','Saginaw','MI','US','+1 517 123 4191','us','AMERICA','200','Maurice.Hasan@STILT.COM',149);
        insert into oehr_customers values (120,'Diane','Higgins','113 Washington Sq N','48933','Lansing','MI','US','+1 517 123 4199','us','AMERICA','200','Diane.Higgins@TANAGER.COM',149);
        insert into oehr_customers values (121,'Dianne','Sen','2500 S Pennsylvania Ave','48910','Lansing','MI','US','+1 517 123 4201','us','AMERICA','200','Dianne.Sen@TATTLER.COM',149);
        insert into oehr_customers values (122,'Maurice','Daltrey','3213 S Cedar St','48910','Lansing','MI','US','+1 517 123 4206','us','AMERICA','200','Maurice.Daltrey@TEAL.COM',NULL);
        insert into oehr_customers values (123,'Elizabeth','Brown','8110 Jackson Rd','48103','Ann Arbor','MI','US','+1 313 123 4219','us','AMERICA','200','Elizabeth.Brown@THRASHER.COM',149);
        insert into oehr_customers values (124,'Diane','Mason','6654 W Lafayette St','48226','Detroit','MI','US','+1 313 123 4222','us','AMERICA','200','Diane.Mason@TROGON.COM',149);
        insert into oehr_customers values (125,'Dianne','Andrews','27 Benton Rd','48602','Saginaw','MI','US','+1 517 123 4225','us','AMERICA','200','Dianne.Andrews@TURNSTONE.COM',149);
        insert into oehr_customers values (126,'Charles','Field','8201 Livernois Ave','48204','Detroit','MI','US','+1 313 123 4226','us','AMERICA','300','Charles.Field@BECARD.COM',NULL);
        insert into oehr_customers values (127,'Charles','Broderick','101 N Falahee Rd','49203','Jackson','MI','US','+1 517 123 4228','us','AMERICA','300','Charles.Broderick@BITTERN.COM',NULL);
        insert into oehr_customers values (128,'Isabella','Reed','3100 E Eisenhower Pky # 100','48108','Ann Arbor','MI','US','+1 313 123 4230','us','AMERICA','300','Isabella.Reed@BRANT.COM',NULL);
        insert into oehr_customers values (129,'Louis','Jackson','952 Vassar Dr','49001','Kalamazoo','MI','US','+1 616 123 4234','us','AMERICA','400','Louis.Jackson@CARACARA.COM',149);
        insert into oehr_customers values (130,'Louis','Edwards','150 W Jefferson Ave # 2500','48226','Detroit','MI','US','+1 313 123 4242','us','AMERICA','400','Louis.Edwards@CHACHALACA.COM',NULL);
        insert into oehr_customers values (131,'Doris','Dutt','40 Pearl St Nw # 1020','49503','Grand Rapids','MI','US','+1 616 123 4245','us','AMERICA','400','Doris.Dutt@CHUKAR.COM',NULL);
        insert into oehr_customers values (132,'Doris','Spacek','1135 Catherine St','48109','Ann Arbor','MI','US','+1 313 123 4248','us','AMERICA','400','Doris.Spacek@FLICKER.COM',NULL);
        insert into oehr_customers values (133,'Kristin','Malden','301 E Genesee Ave','48607','Saginaw','MI','US','+1 517 123 4253','us','AMERICA','400','Kristin.Malden@GODWIT.COM',149);
        insert into oehr_customers values (134,'Sissy','Puri','9936 Dexter Ave','48206','Detroit','MI','US','+1 313 123 4255','us','AMERICA','400','Sissy.Puri@GREBE.COM',NULL);
        insert into oehr_customers values (135,'Doris','Bel Geddes','1660 University Ter','48104','Ann Arbor','MI','US','+1 313 123 4263','us','AMERICA','400','Doris.BelGeddes@GROSBEAK.COM',NULL);
        insert into oehr_customers values (136,'Sissy','Warden','15713 N East St','48906','Lansing','MI','US','+1 517 123 4265','us','AMERICA','400','Sissy.Warden@JACANA.COM',149);
        insert into oehr_customers values (137,'Elia','Brando','555 John F Kennedy Rd','52002','Dubuque','IA','US','+1 319 123 4271','us','AMERICA','500','Elia.Brando@JUNCO.COM',149);
        insert into oehr_customers values (138,'Mani','Fonda','10315 Hickman Rd','50322','Des Moines','IA','US','+1 515 123 4273','us','AMERICA','500','Mani.Fonda@KINGLET.COM',149);
        insert into oehr_customers values (139,'Placido','Kubrick','2115 N Towne Ln Ne','52402','Cedar Rapids','IA','US','+1 319 123 4278','us','AMERICA','500','Placido.Kubrick@SCOTER.COM',NULL);
        insert into oehr_customers values (140,'Claudia','Kurosawa','1928 Sherwood Dr','51503','Council Bluffs','IA','US','+1 712 123 4280','us','AMERICA','500','Claudia.Kurosawa@CHUKAR.COM',NULL);
        insert into oehr_customers values (141,'Maximilian','Henner','2102 E Kimberly Rd','52807','Davenport','IA','US','+1 319 123 4282','us','AMERICA','500','Maximilian.Henner@DUNLIN.COM',145);
        insert into oehr_customers values (142,'Sachin','Spielberg','1691 Asbury Rd','52001','Dubuque','IA','US','+1 319 123 4288','us','AMERICA','500','Sachin.Spielberg@GADWALL.COM',149);
        insert into oehr_customers values (143,'Sachin','Neeson','5112 Sw 9Th St','50315','Des Moines','IA','US','+1 515 123 4290','us','AMERICA','500','Sachin.Neeson@GALLINULE.COM',149);
        insert into oehr_customers values (144,'Sivaji','Landis','221 3Rd Ave Se # 300','52401','Cedar Rapids','IA','US','+1 319 123 4301','us','AMERICA','500','Sivaji.Landis@GOLDENEYE.COM',149);
        insert into oehr_customers values (145,'Mammutti','Pacino','2120 Heights Dr','54701','Eau Claire','WI','US','+1 745 123 4306','us','AMERICA','500','Mammutti.Pacino@GREBE.COM',145);
        insert into oehr_customers values (146,'Elia','Fawcett','8989 N Port Washington Rd','53217','Milwaukee','WI','US','+1 414 123 4307','us','AMERICA','500','Elia.Fawcett@JACANA.COM',NULL);
        insert into oehr_customers values (147,'Ishwarya','Roberts','6555 W Good Hope Rd','53223','Milwaukee','WI','US','+1 414 123 4308','us','AMERICA','600','Ishwarya.Roberts@LAPWING.COM',NULL);
        insert into oehr_customers values (148,'Gustav','Steenburgen','1314 N Stoughton Rd','53714','Madison','WI','US','+1 608 123 4309','us','AMERICA','600','Gustav.Steenburgen@PINTAIL.COM',149);
        insert into oehr_customers values (149,'Markus','Rampling','4715 Sprecher Rd','53704','Madison','WI','US','+1 608 123 4318','us','AMERICA','600','Markus.Rampling@PUFFIN.COM',145);
        insert into oehr_customers values (150,'Goldie','Slater','6161 N 64Th St','53218','Milwaukee','WI','US','+1 414 123 4323','us','AMERICA','700','Goldie.Slater@PYRRHULOXIA.COM',NULL);
        insert into oehr_customers values (151,'Divine','Aykroyd','11016 W Lincoln Ave','53227','Milwaukee','WI','US','+1 414 123 4324','us','AMERICA','700','Divine.Aykroyd@REDSTART.COM',149);
        insert into oehr_customers values (152,'Dieter','Matthau','8600 W National Ave','53227','Milwaukee','WI','US','+1 414 123 4328','us','AMERICA','700','Dieter.Matthau@VERDIN.COM',NULL);
        insert into oehr_customers values (153,'Divine','Sheen','615 N Sherman Ave','53704','Madison','WI','US','+1 608 123 4332','us','AMERICA','700','Divine.Sheen@COWBIRD.COM',149);
        insert into oehr_customers values (154,'Frederic','Grodin','512 E Grand Ave','53511','Beloit','WI','US','+1 608 123 4344','us','AMERICA','700','Frederic.Grodin@CREEPER.COM',149);
        insert into oehr_customers values (155,'Frederico','Romero','600 N Broadway Fl 1','53202','Milwaukee','WI','US','+1 414 123 4347','us','AMERICA','700','Frederico.Romero@CURLEW.COM',145);
        insert into oehr_customers values (156,'Goldie','Montand','5235 N Ironwood Ln','53217','Milwaukee','WI','US','+1 414 123 4348','us','AMERICA','700','Goldie.Montand@DIPPER.COM',149);
        insert into oehr_customers values (157,'Sidney','Capshaw','322 E Michigan St','53202','Milwaukee','WI','US','+1 414 123 4350','us','AMERICA','700','Sidney.Capshaw@DUNLIN.COM',149);
        insert into oehr_customers values (158,'Frederico','Lyon','1400 Bellinger St Fl 4','54703','Eau Claire','WI','US','+1 745 123 4367','us','AMERICA','700','Frederico.Lyon@FLICKER.COM',149);
        insert into oehr_customers values (159,'Eddie','Boyer','411 E Wisconsin Ave # 2550','53202','Milwaukee','WI','US','+1 414 123 4369','us','AMERICA','700','Eddie.Boyer@GALLINULE.COM',NULL);
        insert into oehr_customers values (160,'Eddie','Stern','808 3Rd St # 100','54403','Wausau','WI','US','+1 715 123 4372','us','AMERICA','700','Eddie.Stern@GODWIT.COM',149);
        insert into oehr_customers values (161,'Ernest','Weaver','300 Crooks St','54301','Green Bay','WI','US','+1 414 123 4373','us','AMERICA','900','Ernest.Weaver@GROSBEAK.COM',149);
        insert into oehr_customers values (162,'Ernest','George','122 E Dayton St','53703','Madison','WI','US','+1 608 123 4374','us','AMERICA','900','Ernest.George@LAPWING.COM',149);
        insert into oehr_customers values (163,'Ernest','Chandar','633 S Hawley Rd','53214','Milwaukee','WI','US','+1 414 123 4376','us','AMERICA','900','Ernest.Chandar@LIMPKIN.COM',149);
        insert into oehr_customers values (164,'Charlotte','Kazan','2122 Campbell Rd','54601','La Crosse','WI','US','+1 608 123 4378','us','AMERICA','1200','Charlotte.Kazan@MERGANSER.COM',149);
        insert into oehr_customers values (165,'Charlotte','Fonda','3324 N Oakland Ave','53211','Milwaukee','WI','US','+1 414 123 4381','us','AMERICA','1200','Charlotte.Fonda@MOORHEN.COM',149);
        insert into oehr_customers values (166,'Dheeraj','Alexander','666 22Nd Ave Ne','55418','Minneapolis','MN','US','+1 612 123 4397','us','AMERICA','1200','Dheeraj.Alexander@NUTHATCH.COM',149);
        insert into oehr_customers values (167,'Gerard','Hershey','1501 Lowry Ave N','55411','Minneapolis','MN','US','+1 612 123 4399','us','AMERICA','1200','Gerard.Hershey@PARULA.COM',NULL);
        insert into oehr_customers values (168,'Hema','Voight','113 N 1St St','55401','Minneapolis','MN','US','+1 612 123 4408','us','AMERICA','1200','Hema.Voight@PHALAROPE.COM',145);
        insert into oehr_customers values (169,'Dheeraj','Davis','4200 Yosemite Ave S','55416','Minneapolis','MN','US','+1 612 123 4417','us','AMERICA','1200','Dheeraj.Davis@PIPIT.COM',NULL);
        insert into oehr_customers values (170,'Harry Dean','Fonda','2800 Chicago Ave # 100','55407','Minneapolis','MN','US','+1 612 123 4419','us','AMERICA','1200','HarryDean.Fonda@PLOVER.COM',149);
        insert into oehr_customers values (171,'Hema','Powell','200 1St St Sw','55905','Rochester','MN','US','+1 507 123 4421','us','AMERICA','1200','Hema.Powell@SANDERLING.COM',145);
        insert into oehr_customers values (172,'Harry Mean','Peckinpah','314 W Superior St # 1015','55802','Duluth','MN','US','+1 218 123 4429','us','AMERICA','1200','HarryMean.Peckinpah@VERDIN.COM',149);
        insert into oehr_customers values (173,'Kathleen','Walken','1409 Willow St # 600','55403','Minneapolis','MN','US','+1 612 123 4434','us','AMERICA','1200','Kathleen.Walken@VIREO.COM',149);
        insert into oehr_customers values (174,'Blake','Seignier','2720 Brewerton Rd','13211','Syracuse','NY','US','+1 315 123 4442','us','AMERICA','1200','Blake.Seignier@GALLINULE.COM',149);
        insert into oehr_customers values (175,'Claude','Powell','2134 W Genesee St','13219','Syracuse','NY','US','+1 315 123 4447','us','AMERICA','1200','Claude.Powell@GODWIT.COM',NULL);
        insert into oehr_customers values (176,'Faye','Glenn','1522 Main St','14305','Niagara Falls','NY','US','+1 716 123 4457','us','AMERICA','1200','Faye.Glenn@GREBE.COM',149);
        insert into oehr_customers values (177,'Gerhard','Seignier','49 N Pine Ave','12203','Albany','NY','US','+1 518 123 4459','us','AMERICA','1200','Gerhard.Seignier@JACANA.COM',149);
        insert into oehr_customers values (178,'Grace','Belushi','726 Union St','12534','Hudson','NY','US','+1 518 123 4464','us','AMERICA','1200','Grace.Belushi@KILLDEER.COM',NULL);
        insert into oehr_customers values (179,'Harry dean','Forrest','137 Lark St','12210','Albany','NY','US','+1 518 123 4474','us','AMERICA','1200','Harrydean.Forrest@KISKADEE.COM',149);
        insert into oehr_customers values (180,'Harry dean','Cage','33 Fulton St','12601','Poughkeepsie','NY','US','+1 914 123 4494','us','AMERICA','1200','Harrydean.Cage@LAPWING.COM',149);
        insert into oehr_customers values (181,'Lauren','Hershey','2360 Maxon Rd','12308','Schenectady','NY','US','+1 518 123 4496','us','AMERICA','1200','Lauren.Hershey@LIMPKIN.COM',149);
        insert into oehr_customers values (182,'Lauren','Dench','85 High St','14203','Buffalo','NY','US','+1 716 123 4575','us','AMERICA','1200','Lauren.Dench@LONGSPUR.COM',149);
        insert into oehr_customers values (183,'Lauren','Altman','1 Palisade Ave Fl 2','10701','Yonkers','NY','US','+1 914 123 4578','us','AMERICA','1200','Lauren.Altman@MERGANSER.COM',145);
        insert into oehr_customers values (184,'Mary Beth','Roberts','500 S Salina St # 500','13202','Syracuse','NY','US','+1 315 123 4597','us','AMERICA','1200','MaryBeth.Roberts@NUTHATCH.COM',NULL);
        insert into oehr_customers values (185,'Matthew','Wright','33 Pine St','14094','Lockport','NY','US','+1 716 123 4599','us','AMERICA','1200','Matthew.Wright@OVENBIRD.COM',NULL);
        insert into oehr_customers values (186,'Meena','Alexander','Po Box 2152','14240','Buffalo','NY','US','+1 716 123 4605','us','AMERICA','1200','Meena.Alexander@PARULA.COM',149);
        insert into oehr_customers values (187,'Grace','Dvrrie','2979 Hamburg St','12303','Schenectady','NY','US','+1 518 123 4617','us','AMERICA','1200','Grace.Dvrrie@PHOEBE.COM',NULL);
        insert into oehr_customers values (188,'Charlotte','Buckley','1790 Grand Blvd','12309','Schenectady','NY','US','+1 518 123 4618','us','AMERICA','1200','Charlotte.Buckley@PINTAIL.COM',NULL);
        insert into oehr_customers values (189,'Gena','Harris','7 Ingelside Ln','10605','White Plains','NY','US','+1 914 123 4619','us','AMERICA','1200','Gena.Harris@PIPIT.COM',149);
        insert into oehr_customers values (190,'Gena','Curtis','18 Glenridge Rd','12302','Schenectady','NY','US','+1 518 123 4624','us','AMERICA','1200','Gena.Curtis@PLOVER.COM',149);
        insert into oehr_customers values (191,'Maureen','Sanders','6432 Rising Sun Ave','19111','Philadelphia','PA','US','+1 215 123 4644','us','AMERICA','1200','Maureen.Sanders@PUFFIN.COM',149);
        insert into oehr_customers values (192,'Sean','Stockwell','Rr 10','19606','Reading','PA','US','+1 610 123 4657','us','AMERICA','1200','Sean.Stockwell@PYRRHULOXIA.COM',149);
        insert into oehr_customers values (193,'Harry dean','Kinski','2455 Rose Garden Rd','15220','Pittsburgh','PA','US','+1 412 123 4662','us','AMERICA','1200','Harrydean.Kinski@REDPOLL.COM',149);
        insert into oehr_customers values (194,'Kathleen','Garcia','1812 Timberline Rd','16601','Altoona','PA','US','+1 814 123 4663','us','AMERICA','1200','Kathleen.Garcia@REDSTART.COM',149);
        insert into oehr_customers values (195,'Sean','Olin','141 Schiller St','19601','Reading','PA','US','+1 610 123 4664','us','AMERICA','1200','Sean.Olin@SCAUP.COM',149);
        insert into oehr_customers values (196,'Gerard','Dench','1126 Pawlings Rd','19403','Norristown','PA','US','+1 610 123 4667','us','AMERICA','1200','Gerard.Dench@SCOTER.COM',149);
        insert into oehr_customers values (197,'Gerard','Altman','55 Church Hill Rd','19606','Reading','PA','US','+1 610 123 4669','us','AMERICA','1200','Gerard.Altman@SHRIKE.COM',145);
        insert into oehr_customers values (198,'Maureen','de Funes','354 N Prince St','17603','Lancaster','PA','US','+1 717 123 4674','us','AMERICA','1200','Maureen.deFunes@SISKIN.COM',149);
        insert into oehr_customers values (199,'Clint','Chapman','115 Chestnut St','19106','Philadelphia','PA','US','+1 215 123 4676','us','AMERICA','1400','Clint.Chapman@SNIPE.COM',145);
        insert into oehr_customers values (200,'Clint','Gielgud','2899 Grand Ave','15225','Pittsburgh','PA','US','+1 412 123 4681','us','AMERICA','1400','Clint.Gielgud@STILT.COM',149);
        insert into oehr_customers values (201,'Eric','Prashant','Po Box 39','15701','Indiana','PA','US','+1 412 123 4684','us','AMERICA','1400','Eric.Prashant@TATTLER.COM',149);
        insert into oehr_customers values (202,'Ingrid','Welles','1604 Broadway Ave','15216','Pittsburgh','PA','US','+1 412 123 4688','us','AMERICA','1400','Ingrid.Welles@TEAL.COM',149);
        insert into oehr_customers values (203,'Ingrid','Rampling','4734 Liberty Ave','15224','Pittsburgh','PA','US','+1 412 123 4691','us','AMERICA','1400','Ingrid.Rampling@WIGEON.COM',145);
        insert into oehr_customers values (204,'Cliff','Puri','21 Thornwood Rd','17112','Harrisburg','PA','US','+1 717 123 4692','us','AMERICA','1400','Cliff.Puri@CORMORANT.COM',NULL);
        insert into oehr_customers values (205,'Emily','Pollack','3725 W Lake Rd','16505','Erie','PA','US','+1 814 123 4696','us','AMERICA','1400','Emily.Pollack@DIPPER.COM',145);
        insert into oehr_customers values (206,'Fritz','Hackman','1808 4Th Ave','16602','Altoona','PA','US','+1 814 123 4697','us','AMERICA','1400','Fritz.Hackman@DUNLIN.COM',145);
        insert into oehr_customers values (207,'Cybill','Laughton','Station Sq','15219','Pittsburgh','PA','US','+1 412 123 4700','us','AMERICA','1400','Cybill.Laughton@EIDER.COM',149);
        insert into oehr_customers values (208,'Cyndi','Griem','4020 Garden Ave','16508','Erie','PA','US','+1 814 123 4706','us','AMERICA','1400','Cyndi.Griem@GALLINULE.COM',145);
        insert into oehr_customers values (209,'Cyndi','Collins','100 N Peach St','19139','Philadelphia','PA','US','+1 215 123 4708','us','AMERICA','1400','Cyndi.Collins@GODWIT.COM',149);
        insert into oehr_customers values (210,'Cybill','Clapton','835 Heister Ln','19605','Reading','PA','US','+1 610 123 4714','us','AMERICA','1400','Cybill.Clapton@GOLDENEYE.COM',149);
        insert into oehr_customers values (211,'Luchino','Jordan','378 S Negley Ave','15232','Pittsburgh','PA','US','+1 412 123 4718','us','AMERICA','1500','Luchino.Jordan@GREBE.COM',149);
        insert into oehr_customers values (212,'Luchino','Falk','5643 N 5Th St','19120','Philadelphia','PA','US','+1 215 123 4721','us','AMERICA','1500','Luchino.Falk@OVENBIRD.COM',149);
        insert into oehr_customers values (213,'Luchino','Bradford','1401 W Warren Rd','16701','Bradford','PA','US','+1 814 123 4722','us','AMERICA','1500','Luchino.Bradford@PARULA.COM',149);
        insert into oehr_customers values (214,'Robin','Danson','815 Freeport Rd','15215','Pittsburgh','PA','US','+1 412 123 4724','us','AMERICA','1500','Robin.Danson@PHAINOPEPLA.COM',149);
        insert into oehr_customers values (215,'Orson','Perkins','327 N Washington Ave # 300','18503','Scranton','PA','US','+1 717 123 4730','us','AMERICA','1900','Orson.Perkins@PINTAIL.COM',149);
        insert into oehr_customers values (216,'Orson','Koirala','810 Race St','19107','Philadelphia','PA','US','+1 215 123 4738','us','AMERICA','1900','Orson.Koirala@PIPIT.COM',149);
        insert into oehr_customers values (217,'Bryan','Huston','4901 Locust Ln','17109','Harrisburg','PA','US','+1 717 123 4739','us','AMERICA','2300','Bryan.Huston@PYRRHULOXIA.COM',149);
        insert into oehr_customers values (218,'Bryan','Dvrrie','3376 Perrysville Ave','15214','Pittsburgh','PA','US','+1 412 123 4740','us','AMERICA','2300','Bryan.Dvrrie@REDPOLL.COM',149);
        insert into oehr_customers values (219,'Ajay','Sen','220 Penn Ave # 300','18503','Scranton','PA','US','+1 717 123 4741','us','AMERICA','2300','Ajay.Sen@TROGON.COM',149);
        insert into oehr_customers values (220,'Carol','Jordan','135 S 18Th St # 1','19103','Philadelphia','PA','US','+1 215 123 4743','us','AMERICA','2300','Carol.Jordan@TURNSTONE.COM',149);
        insert into oehr_customers values (221,'Carol','Bradford','522 Swede St','19401','Norristown','PA','US','+1 610 123 4744','us','AMERICA','2300','Carol.Bradford@VERDIN.COM',NULL);
        insert into oehr_customers values (222,'Cary','Stockwell','7708 City Ave','19151','Philadelphia','PA','US','+1 215 123 4745','us','AMERICA','2300','Cary.Stockwell@VIREO.COM',NULL);
        insert into oehr_customers values (223,'Cary','Olin','1801 Lititz Pike','17601','Lancaster','PA','US','+1 717 123 4746','us','AMERICA','2300','Cary.Olin@WATERTHRUSH.COM',149);
        insert into oehr_customers values (224,'Clara','Krige','101 E Olney Ave','19120','Philadelphia','PA','US','+1 215 123 4748','us','AMERICA','2300','Clara.Krige@WHIMBREL.COM',NULL);
        insert into oehr_customers values (225,'Clara','Ganesan','612 Jefferson Ave','18510','Scranton','PA','US','+1 717 123 4752','us','AMERICA','2300','Clara.Ganesan@WIGEON.COM',149);
        insert into oehr_customers values (226,'Ajay','Andrews','223 4Th Ave # 1100','15222','Pittsburgh','PA','US','+1 412 123 4763','us','AMERICA','2300','Ajay.Andrews@YELLOWTHROAT.COM',149);
        insert into oehr_customers values (227,'Kathy','Prashant','36 W 34Th St','16508','Erie','PA','US','+1 814 123 4766','us','AMERICA','2400','Kathy.Prashant@ANI.COM',149);
        insert into oehr_customers values (228,'Graham','Neeson','1007 Mount Royal Blvd','15223','Pittsburgh','PA','US','+1 412 123 4767','us','AMERICA','2400','Graham.Neeson@AUKLET.COM',145);
        insert into oehr_customers values (229,'Ian','Chapman','601 Market St','19106','Philadelphia','PA','US','+1 215 123 4768','us','AMERICA','2400','Ian.Chapman@AVOCET.COM',145);
        insert into oehr_customers values (230,'Danny','Wright','5565 Baynton St','19144','Philadelphia','PA','US','+1 215 123 4771','us','AMERICA','2400','Danny.Wright@BITTERN.COM',149);
        insert into oehr_customers values (231,'Danny','Rourke','5640 Fishers Ln','20852','Rockville','MD','US','+1 301 123 4794','us','AMERICA','2400','Danny.Rourke@BRANT.COM',149);
        insert into oehr_customers values (232,'Donald','Hunter','5122 Sinclair Ln','21206','Baltimore','MD','US','+1 410 123 4795','us','AMERICA','2400','Donald.Hunter@CHACHALACA.COM',149);
        insert into oehr_customers values (233,'Graham','Spielberg','680 Bel Air Rd','21014','Bel Air','MD','US','+1 410 123 4800','us','AMERICA','2400','Graham.Spielberg@CHUKAR.COM',145);
        insert into oehr_customers values (234,'Dan','Roberts','4301 Ashland Ave','21205','Baltimore','MD','US','+1 410 123 4805','us','AMERICA','2400','Dan.Roberts@NUTHATCH.COM',149);
        insert into oehr_customers values (235,'Edward','Oates','8004 Stansbury Rd','21222','Baltimore','MD','US','+1 410 012 4715','us','AMERICA','2400','Edward.Oates@OVENBIRD.COM',NULL);
        insert into oehr_customers values (236,'Edward','Julius','10209 Yearling Dr','20850','Rockville','MD','US','+1 301 123 4809','us','AMERICA','2400','Edward.Julius@PARULA.COM',NULL);
        insert into oehr_customers values (237,'Farrah','Quinlan','3000 Greenmount Ave','21218','Baltimore','MD','US','+1 410 123 4812','us','AMERICA','2400','Farrah.Quinlan@PHAINOPEPLA.COM',149);
        insert into oehr_customers values (238,'Farrah','Lange','200 E Fort Ave','21230','Baltimore','MD','US','+1 410 123 4813','us','AMERICA','2400','Farrah.Lange@PHALAROPE.COM',149);
        insert into oehr_customers values (239,'Hal','Stockwell','1262 Vocke Rd','21502','Cumberland','MD','US','+1 301 123 4814','us','AMERICA','2400','Hal.Stockwell@PHOEBE.COM',NULL);
        insert into oehr_customers values (240,'Malcolm','Kanth','3314 Eastern Ave','21224','Baltimore','MD','US','+1 410 123 4816','us','AMERICA','2400','Malcolm.Kanth@PIPIT.COM',145);
        insert into oehr_customers values (241,'Malcolm','Broderick','12817 Coastal Hwy','21842','Ocean City','MD','US','+1 410 123 4817','us','AMERICA','2400','Malcolm.Broderick@PLOVER.COM',145);
        insert into oehr_customers values (242,'Mary','Lemmon','11200 Scaggsville Rd','20723','Laurel','MD','US','+1 301 123 4818','us','AMERICA','2400','Mary.Lemmon@PUFFIN.COM',145);
        insert into oehr_customers values (243,'Mary','Collins','9435 Washington Blvd N # M','20723','Laurel','MD','US','+1 301 123 4819','us','AMERICA','2400','Mary.Collins@PYRRHULOXIA.COM',149);
        insert into oehr_customers values (244,'Matt','Gueney','2300 Harford Rd','21218','Baltimore','MD','US','+1 410 123 4822','us','AMERICA','2400','Matt.Gueney@REDPOLL.COM',149);
        insert into oehr_customers values (245,'Max','von Sydow','2 2Nd St # A','21842','Ocean City','MD','US','+1 410 123 4840','us','AMERICA','2400','Max.vonSydow@REDSTART.COM',149);
        insert into oehr_customers values (246,'Max','Schell','6917 W Oklahoma Ave','53219','Milwaukee','WI','US','+1 414 123 4363','us','AMERICA','2400','Max.Schell@SANDERLING.COM',NULL);
        insert into oehr_customers values (247,'Cynda','Whitcraft','206 S Broadway # 707','55904','Rochester','MN','US','+1 507 123 4387','us','AMERICA','2400','Cynda.Whitcraft@SANDPIPER.COM',149);
        insert into oehr_customers values (248,'Donald','Minnelli','160 Glenwood Ave','55405','Minneapolis','MN','US','+1 612 123 4436','us','AMERICA','2400','Donald.Minnelli@SCAUP.COM',149);
        insert into oehr_customers values (249,'Hannah','Broderick','6915 Grand Ave','46323','Hammond','IN','US','+1 219 123 4145','us','AMERICA','2400','Hannah.Broderick@SHRIKE.COM',149);
        insert into oehr_customers values (250,'Dan','Williams','2215 Oak Industrial Dr Ne','49505','Grand Rapids','MI','US','+1 616 123 4190','us','AMERICA','2400','Dan.Williams@SISKIN.COM',145);
        insert into oehr_customers values (251,'Raul','Wilder','65 Cadillac Sq # 2701','48226','Detroit','MI','US','+1 313 123 4241','us','AMERICA','2500','Raul.Wilder@STILT.COM',NULL);
        insert into oehr_customers values (252,'Shah Rukh','Field','3435 Tuscany Dr Se','49546','Grand Rapids','MI','US','+1 616 123 4259','us','AMERICA','2500','ShahRukh.Field@WHIMBREL.COM',NULL);
        insert into oehr_customers values (253,'Sally','Bogart','215 4Th Ave Se','52401','Cedar Rapids','IA','US','+1 319 123 4269','us','AMERICA','2500','Sally.Bogart@WILLET.COM',NULL);
        insert into oehr_customers values (254,'Bruce','Bates','1751 Madison Ave','51503','Council Bluffs','IA','US','+1 712 123 4284','us','AMERICA','3500','Bruce.Bates@COWBIRD.COM',NULL);
        insert into oehr_customers values (255,'Brooke','Shepherd','810 1St Ave','51501','Council Bluffs','IA','US','+1 712 123 4289','us','AMERICA','3500','Brooke.Shepherd@KILLDEER.COM',NULL);
        insert into oehr_customers values (256,'Ben','de Niro','500 W Oklahoma Ave','53207','Milwaukee','WI','US','+1 414 123 4312','us','AMERICA','3500','Ben.deNiro@KINGLET.COM',149);
        insert into oehr_customers values (257,'Emmet','Walken','4811 S 76Th St # 205','53220','Milwaukee','WI','US','+1 414 123 4364','us','AMERICA','3600','Emmet.Walken@LIMPKIN.COM',145);
        insert into oehr_customers values (258,'Ellen','Palin','310 Broadway St','56308','Alexandria','MN','US','+1 320 123 4385','us','AMERICA','3600','Ellen.Palin@LONGSPUR.COM',149);
      end;~';
   insert into wwv_sample_dmls (wwv_sample_dataset_id, language_cd, dml_name, install_seq, dml) 
   values (  3, 'en', 'Insert Into customers (Part 1)', 20, l_clob);

   l_clob :=q'~begin
        insert into oehr_customers values (259,'Denholm','von Sydow','1721 E Lake St','55407','Minneapolis','MN','US','+1 612 123 4407','us','AMERICA','3600','Denholm.vonSydow@MERGANSER.COM',145);
        insert into oehr_customers values (260,'Ellen','Khan','255 Great Arrow Ave','14207','Buffalo','NY','US','+1 716 123 4456','us','AMERICA','3600','Ellen.Khan@VERDIN.COM',149);
        insert into oehr_customers values (261,'Emmet','Garcia','800 Carter St','14621','Rochester','NY','US','+1 716 123 4582','us','AMERICA','3600','Emmet.Garcia@VIREO.COM',145);
        insert into oehr_customers values (262,'Fred','Reynolds','6640 Campbell Blvd','14094','Lockport','NY','US','+1 716 123 4627','us','AMERICA','3600','Fred.Reynolds@WATERTHRUSH.COM',149);
        insert into oehr_customers values (263,'Fred','Lithgow','802 North Ave','15209','Pittsburgh','PA','US','+1 412 123 4677','us','AMERICA','3600','Fred.Lithgow@WHIMBREL.COM',NULL);
        insert into oehr_customers values (264,'George','Adjani','1136 Arch St','19107','Philadelphia','PA','US','+1 215 123 4702','us','AMERICA','3600','George.Adjani@WILLET.COM',149);
        insert into oehr_customers values (265,'Irene','Laughton','6Th And Master St','19122','Philadelphia','PA','US','+1 215 123 4749','us','AMERICA','3600','Irene.Laughton@ANHINGA.COM',149);
        insert into oehr_customers values (266,'Prem','Cardinale','Rt 6 E','16365','Warren','PA','US','+1 814 123 4755','us','AMERICA','3700','Prem.Cardinale@BITTERN.COM',145);
        insert into oehr_customers values (267,'Prem','Walken','1924 Bedford St','21502','Cumberland','MD','US','+1 301 123 4831','us','AMERICA','3700','Prem.Walken@BRANT.COM',145);
        insert into oehr_customers values (268,'Kyle','Schneider','2674 Collingwood St','48206','Detroit','MI','US','+1 313 123 4167','us','AMERICA','3700','Kyle.Schneider@DUNLIN.COM',149);
        insert into oehr_customers values (269,'Kyle','Martin','2713 N Bendix Dr','46628','South Bend','IN','US','+1 219 123 4116','us','AMERICA','3700','Kyle.Martin@EIDER.COM',149);
        insert into oehr_customers values (270,'Meg','Derek','23985 Bedford Rd N','49017','Battle Creek','MI','US','+1 616 123 4166','us','AMERICA','3700','Meg.Derek@FLICKER.COM',NULL);
        insert into oehr_customers values (271,'Shelley','Peckinpah','752 W Huron St','48341','Pontiac','MI','US','+1 810 123 4212','us','AMERICA','3700','Shelley.Peckinpah@GODWIT.COM',149);
        insert into oehr_customers values (272,'Prem','Garcia','660 Woodward Ave # 2290','48226','Detroit','MI','US','+1 313 123 4240','us','AMERICA','3700','Prem.Garcia@JACANA.COM',145);
        insert into oehr_customers values (273,'Bo','Hitchcock','1330 N Memorial Dr','53404','Racine','WI','US','+1 414 123 4340','us','AMERICA','5000','Bo.Hitchcock@ANHINGA.COM',NULL);
        insert into oehr_customers values (274,'Bob','McCarthy','701 Seneca St','14210','Buffalo','NY','US','+1 716 123 4485','us','AMERICA','5000','Bob.McCarthy@ANI.COM',NULL);
        insert into oehr_customers values (275,'Dom','McQueen','8 Automation Ln','12205','Albany','NY','US','+1 518 123 4532','us','AMERICA','5000','Dom.McQueen@AUKLET.COM',145);
        insert into oehr_customers values (276,'Dom','Hoskins','811 N Brandywine Ave','12308','Schenectady','NY','US','+1 518 123 4562','us','AMERICA','5000','Dom.Hoskins@AVOCET.COM',145);
        insert into oehr_customers values (277,'Don','Siegel','2904 S Salina St','13205','Syracuse','NY','US','+1 315 123 4585','us','AMERICA','5000','Don.Siegel@BITTERN.COM',149);
        insert into oehr_customers values (278,'Gvtz','Bradford','3025 Sussex Ave','15226','Pittsburgh','PA','US','+1 412 123 4659','us','AMERICA','5000','Gvtz.Bradford@BULBUL.COM',NULL);
        insert into oehr_customers values (279,'Holly','Kurosawa','932 High St','17603','Lancaster','PA','US','+1 717 123 4679','us','AMERICA','5000','Holly.Kurosawa@CARACARA.COM',NULL);
        insert into oehr_customers values (280,'Rob','MacLaine','5344 Haverford Ave','19139','Philadelphia','PA','US','+1 215 123 4709','us','AMERICA','5000','Rob.MacLaine@COOT.COM',149);
        insert into oehr_customers values (281,'Don','Barkin','6959 Tulip St','19135','Philadelphia','PA','US','+1 215 123 4751','us','AMERICA','5000','Don.Barkin@CORMORANT.COM',149);
        insert into oehr_customers values (282,'Kurt','Danson','511 S Central Ave # A','21202','Baltimore','MD','US','+1 410 123 4807','us','AMERICA','5000','Kurt.Danson@COWBIRD.COM',149);
        insert into oehr_customers values (283,'Kurt','Heard','400 E Joppa Rd','21286','Baltimore','MD','US','+1 410 123 4829','us','AMERICA','5000','Kurt.Heard@CURLEW.COM',NULL);
        insert into oehr_customers values (308,'Glenda','Dunaway','1795 Wu Meng','21191','Muang Chonburi',null,'CN','+86 811 012 4093','zhs','CHINA','1200','Glenda.Dunaway@DOWITCHER.COM',149);
        insert into oehr_customers values (309,'Glenda','Bates','1796 Tsing Tao','11111','Muang Nonthaburi',null,'CN','+86 123 012 4095','zhs','CHINA','1200','Glenda.Bates@DIPPER.COM',149);
        insert into oehr_customers values (323,'Goetz','Falk','1810 Tucker Crt','361181','Mumbai',null,'IN','+91 80 012 4123','hi','INDIA','5000','Goetz.Falk@VEERY.COM',NULL);
        insert into oehr_customers values (326,'Hal','Olin','Walpurgisstr 69','81243','Munich',null,'DE','+49 89 012 4129','d','GERMANY','2400','Hal.Olin@FLICKER.COM',149);
        insert into oehr_customers values (327,'Hannah','Kanth','Sendlinger Tor 4','81696','Munich',null,'DE','+49 90 012 4131','d','GERMANY','2400','Hannah.Kanth@GADWALL.COM',149);
        insert into oehr_customers values (328,'Hannah','Field','Theresienstr 15','81999','Munich',null,'DE','+49 91 012 4133','d','GERMANY','2400','Hannah.Field@GALLINULE.COM',149);
        insert into oehr_customers values (333,'Margret','Powell','Via Frenzy 6903','361196','Roma',null,'IT','+39 6 012 4543','i','ITALY','1200','Margret.Powell@ANI.COM',NULL);
        insert into oehr_customers values (334,'Harry Mean','Taylor','1822 Ironweed St','91261','Toronto','ONT','CA','+1 416 012 4147','us','AMERICA','1200','HarryMean.Taylor@REDPOLL.COM',149);
        insert into oehr_customers values (335,'Margrit','Garner','Via Luminosa 162','361197','Firenze',null,'IT','+39 55 012 4547','i','ITALY','500','Margrit.Garner@STILT.COM',149);
        insert into oehr_customers values (337,'Maria','Warden','Via Notoriosa 1932 Rd','361198','Firenze',null,'IT','+39 55 012 4551','i','ITALY','500','Maria.Warden@TANAGER.COM',149);
        insert into oehr_customers values (339,'Marilou','Landis','Via Notoriosa 1941','361199','Firenze',null,'IT','+39 55 012 4555','i','ITALY','500','Marilou.Landis@TATTLER.COM',149);
        insert into oehr_customers values (361,'Marilou','Chapman','Via Notoriosa 1942','361200','Firenze',null,'IT','+39 55 012 4559','i','ITALY','500','Marilou.Chapman@TEAL.COM',145);
        insert into oehr_customers values (363,'Kathy','Lambert','Via Delle Grazie 11','361225','Tellaro',null,'IT','+39 10 012 4363','i','ITALY','2400','Kathy.Lambert@COOT.COM',145);
        insert into oehr_customers values (360,'Helmut','Capshaw','1831 No Wong','111181','Peking',null,'CN','+86 10 012 4165','zhs','CHINA','3600','Helmut.Capshaw@TROGON.COM',145);
        insert into oehr_customers values (341,'Keir','George','Via Dolorosa 69','361229','Tellaro',null,'IT','+39 10 012 4365','i','ITALY','700','Keir.George@VIREO.COM',NULL);
        insert into oehr_customers values (342,'Marlon','Laughton','Via Notoriosa 1943','361201','Firenze',null,'IT','+39 55 012 4565','i','ITALY','2400','Marlon.Laughton@CORMORANT.COM',149);
        insert into oehr_customers values (343,'Keir','Chandar','Via Luminosa 162','361231','Tellaro',null,'IT','+39 10 012 4367','i','ITALY','700','Keir.Chandar@WATERTHRUSH.COM',149);
        insert into oehr_customers values (344,'Marlon','Godard','2017 Convoy St','876508','Tokyo',null,'JP','+81 565 012 4567','ja','JAPAN','2400','Marlon.Godard@MOORHEN.COM',149);
        insert into oehr_customers values (345,'Keir','Weaver','Via Di Firenze 231','361228','Tellaro',null,'IT','+39 10 012 4369','i','ITALY','700','Keir.Weaver@WHIMBREL.COM',NULL);
        insert into oehr_customers values (346,'Marlon','Clapton','Via Notoriosa 1949','361202','Firenze',null,'IT','+39 55 012 4569','i','ITALY','2400','Marlon.Clapton@COWBIRD.COM',149);
        insert into oehr_customers values (347,'Kelly','Quinlan','Via Frenzy 6903','361230','Tellaro',null,'IT','+39 10 012 4371','i','ITALY','3600','Kelly.Quinlan@PYRRHULOXIA.COM',149);
        insert into oehr_customers values (348,'Kelly','Lange','Piazza Del Congresso 22','361219','San Giminiano',null,'IT','+39 49 012 4373','i','ITALY','3600','Kelly.Lange@SANDPIPER.COM',149);
        insert into oehr_customers values (349,'Ken','Glenn','Piazza Quattre Stagioni 4','361220','San Giminiano',null,'IT','+39 49 012 4375','i','ITALY','3600','Ken.Glenn@SAW-WHET.COM',149);
        insert into oehr_customers values (350,'Ken','Chopra','Piazza Cacchiatore 23','361218','San Giminiano',null,'IT','+39 49 012 4377','i','ITALY','3600','Ken.Chopra@SCAUP.COM',149);
        insert into oehr_customers values (351,'Ken','Wenders','Via Notoriosa 1932','361232','Tellaro',null,'IT','+39 10 012 4379','i','ITALY','3600','Ken.Wenders@REDPOLL.COM',149);
        insert into oehr_customers values (352,'Kenneth','Redford','Via Notoriosa 1949','361236','Ventimiglia',null,'IT','+39 10 012 4381','i','ITALY','3600','Kenneth.Redford@REDSTART.COM',149);
        insert into oehr_customers values (378,'Meg','Sen','2033 Spartacus St',null,'Samutprakarn',null,'TH','+66 76 012 4633','th','THAILAND','3700','Meg.Sen@COWBIRD.COM',149);
        insert into oehr_customers values (380,'Meryl','Holden','2034 Sabrina Rd','361182','Samutprakarn',null,'IN','+91 80 012 4637','hi','INDIA','3700','Meryl.Holden@DIPPER.COM',149);
        insert into oehr_customers values (447,'Richard','Coppola','Piazza Svizzera','361211','Milano',null,'IT','+39 2 012 4771','i','ITALY','500','Richard.Coppola@SISKIN.COM',NULL);
        insert into oehr_customers values (448,'Richard','Winters','Ruella Delle Spiriti','361212','Milano',null,'IT','+39 2 012 4773','i','ITALY','500','Richard.Winters@SNIPE.COM',149);
        insert into oehr_customers values (449,'Rick','Romero','Via Del Disegno 194','361213','Milano',null,'IT','+39 2 012 4775','i','ITALY','1500','Rick.Romero@LONGSPUR.COM',145);
        insert into oehr_customers values (450,'Rick','Lyon','Via Delle Capeletti 52','361214','San Giminiano',null,'IT','+39 49 012 4777','i','ITALY','1500','Rick.Lyon@MERGANSER.COM',149);
        insert into oehr_customers values (451,'Ridley','Hackman','Via Delle Grazie 11','361215','San Giminiano',null,'IT','+39 49 012 4779','i','ITALY','700','Ridley.Hackman@ANHINGA.COM',145);
        insert into oehr_customers values (452,'Ridley','Coyote','Via Delli Capelli 2','361216','San Giminiano',null,'IT','+39 49 012 4781','i','ITALY','700','Ridley.Coyote@ANI.COM',NULL);
        insert into oehr_customers values (453,'Ridley','Young','1592 Silverado St','361123','Bangalore','Kar','IN','+91 80 012 4783','hi','INDIA','700','Ridley.Young@CHUKAR.COM',149);
        insert into oehr_customers values (454,'Rob','Russell','1593 Silverado St','361112','Bangalore','Kar','IN','+91 80 012 4785','hi','INDIA','5000','Rob.Russell@VERDIN.COM',NULL);
        insert into oehr_customers values (458,'Robert','de Niro','1597 Legend St',null,'Mysore','Kar','IN','+91 80 012 4793','hi','INDIA','3700','Robert.deNiro@DOWITCHER.COM',NULL);
        insert into oehr_customers values (463,'Robin','Adjani','1602 Sholay St',null,'Chennai','Tam','IN','+91 80 012 4803','hi','INDIA','1500','Robin.Adjani@MOORHEN.COM',149);
        insert into oehr_customers values (466,'Rodolfo','Hershey','1605 Bazigar Crt',null,'Pune',null,'IN','+91 80 012 4809','hi','INDIA','5000','Rodolfo.Hershey@VIREO.COM',NULL);
        insert into oehr_customers values (467,'Rodolfo','Dench','1606 Sangam Blvd','361196','New Delhi',null,'IN','+91 11 012 4811','hi','INDIA','5000','Rodolfo.Dench@SCOTER.COM',149);
        insert into oehr_customers values (468,'Rodolfo','Altman','1607 Sangam Blvd','361114','New Delhi',null,'IN','+91 11 012 4813','hi','INDIA','5000','Rodolfo.Altman@SHRIKE.COM',145);
        insert into oehr_customers values (470,'Roger','Mastroianni','1609 Pakija Rd',null,'New Delhi',null,'IN','+91 11 012 4817','hi','INDIA','3700','Roger.Mastroianni@CREEPER.COM',149);
        insert into oehr_customers values (473,'Rolf','Ashby','1612 Talaivar St',null,'Chennai','Tam','IN','+91 80 012 4823','hi','INDIA','5000','Rolf.Ashby@WATERTHRUSH.COM',NULL);
        insert into oehr_customers values (474,'Romy','Sharif','1613 Victoria St',null,'Calcutta',null,'IN','+91 33 012 4825','hi','INDIA','5000','Romy.Sharif@SNIPE.COM',145);
        insert into oehr_customers values (475,'Romy','McCarthy','1614 Gitanjali Rd','361168','Calcutta',null,'IN','+91 33 012 4827','hi','INDIA','5000','Romy.McCarthy@STILT.COM',145);
        insert into oehr_customers values (476,'Rosanne','Hopkins','1615 Crackers Crt','361168','Chennai - India',null,'IN','+91 80 012 4829','hi','INDIA','300','Rosanne.Hopkins@ANI.COM',149);
        insert into oehr_customers values (477,'Rosanne','Douglas','1616 Mr. India Ln','361168','Bombay - India','Kar','IN','+91 22 012 4831','hi','INDIA','300','Rosanne.Douglas@ANHINGA.COM',149);
        insert into oehr_customers values (478,'Rosanne','Baldwin','1617 Crackers St','361168','Bangalore - India','Kar','IN','+91 80 012 4833','hi','INDIA','300','Rosanne.Baldwin@AUKLET.COM',149);
        insert into oehr_customers values (479,'Roxanne','Shepherd','1618 Villains St','361168','New Delhi - India',null,'IN','+91 11 012 4835','hi','INDIA','1200','Roxanne.Shepherd@DUNLIN.COM',149);
        insert into oehr_customers values (480,'Roxanne','Michalkow','1619 Bowlers Rd','361168','Chandigarh','Har','IN','+91 172 012 4837','hi','INDIA','1200','Roxanne.Michalkow@EIDER.COM',149);
        insert into oehr_customers values (481,'Roy','Hulce','1620 Sixers Crt','361168','Bombay','Kar','IN','+91 22 012 4839','hi','INDIA','5000','Roy.Hulce@SISKIN.COM',NULL);
        insert into oehr_customers values (482,'Roy','Dunaway','1622 Roja St','361168','Chennai','Tam','IN','+91 80 012 4841','hi','INDIA','5000','Roy.Dunaway@WHIMBREL.COM',149);
        insert into oehr_customers values (483,'Roy','Bates','1623 Hey Ram St','361168','Chennai - India',null,'IN','+91 80 012 4843','hi','INDIA','5000','Roy.Bates@WIGEON.COM',NULL);
        insert into oehr_customers values (487,'Rufus','Dvrrie','1627 Sowdagar St','361168','New Delhi',null,'IN','+91 11 012 4851','hi','INDIA','1900','Rufus.Dvrrie@PLOVER.COM',NULL);
        insert into oehr_customers values (488,'Rufus','Belushi','1628 Pataudi St','361168','New Delhi',null,'IN','+91 11 012 4853','hi','INDIA','1900','Rufus.Belushi@PUFFIN.COM',NULL);
        insert into oehr_customers values (492,'Sally','Edwards','1632 Splash St','361168','Chandigarh','Har','IN','+91 172 012 4861','hi','INDIA','2500', 'Sally.Edwards@TURNSTONE.COM',NULL);
        insert into oehr_customers values (496,'Scott','Jordan','1636 Pretty Blvd','361168','Bangalore','Kar','IN','+91 80 012 4869','hi','INDIA','5000','Scott.Jordan@WILLET.COM',149);
        insert into oehr_customers values (605,'Shammi','Pacino','1646 Brazil Blvd','361168','Chennai','Tam','IN','+91 80 012 4887','hi','INDIA','500','Shammi.Pacino@BITTERN.COM',145);
        insert into oehr_customers values (606,'Sharmila','Kazan','1647 Suspense St','361168','Cochin','Ker','IN','+91 80 012 4889','hi','INDIA','500','Sharmila.Kazan@BRANT.COM',145);
        insert into oehr_customers values (607,'Sharmila','Fonda','1648 Anamika St','361168','Cochin','Ker','IN','+91 80 012 4891','hi','INDIA','500','Sharmila.Fonda@BUFFLEHEAD.COM',145);
        insert into oehr_customers values (609,'Shelley','Taylor','1650 Teesri Manjil Crt','361168','Kashmir',null,'IN','+91 141 012 4895','hi','INDIA','3700','Shelley.Taylor@CURLEW.COM',NULL);
        insert into oehr_customers values (615,'Shyam','Plummer','1656 Veterans Rd','361168','Chennai','Tam','IN','+91 80 012 4907','hi','INDIA','2500','Shyam.Plummer@VEERY.COM',145);
        insert into oehr_customers values (621,'Silk','Kurosawa','1662 Talaivar St','361168','Chennai','Tam','IN','+91 80 012 4919','hi','INDIA','1500','Silk.Kurosawa@NUTHATCH.COM',NULL);
        insert into oehr_customers values (627,'Sivaji','Gielgud','1667 2010 St','61311','Batavia','Ker','IN','+91 80 012 4931','hi','INDIA','500','Sivaji.Gielgud@BULBUL.COM',NULL);
        insert into oehr_customers values (712,'M. Emmet','Stockwell','Piazza Del Congresso 22','361185','Roma',null,'IT','+39 6 012 4501','i','ITALY','3700','M.Emmet.Stockwell@COOT.COM',145);
        insert into oehr_customers values (713,'M. Emmet','Olin','Piazza Quattre Stagioni 4','361186','Roma',null,'IT','+39 6 012 4503','i','ITALY','3700','M.Emmet.Olin@CORMORANT.COM',145);
        insert into oehr_customers values (715,'Malcolm','Field','Piazza Svizzera','361187','Roma',null,'IT','+39 6 012 4507','i','ITALY','2400','Malcolm.Field@DOWITCHER.COM',145);
        insert into oehr_customers values (717,'Mammutti','Sutherland','Ruella Delle Spiriti','361188','Roma',null,'IT','+39 6 012 4511','i','ITALY','500','Mammutti.Sutherland@TOWHEE.COM',145);
        insert into oehr_customers values (719,'Mani','Kazan','Via Del Disegno 194','361189','Roma',null,'IT','+39 6 012 4515','i','ITALY','500','Mani.Kazan@TROGON.COM',149);
        insert into oehr_customers values (721,'Mani','Buckley','Via Delle Capeletti 52','361190','Roma',null,'IT','+39 6 012 4519','i','ITALY','500','Mani.Buckley@TURNSTONE.COM',149);
        insert into oehr_customers values (727,'Margaret','Ustinov','Via Dello Croce 93','361193','Roma',null,'IT','+39 6 012 4531','i','ITALY','1200','Margaret.Ustinov@ANHINGA.COM',149);
        insert into oehr_customers values (729,'Margaux','Krige','Via Di Firenze 231','361194','Roma',null,'IT','+39 6 012 4535','i','ITALY','2400','Margaux.Krige@DUNLIN.COM',NULL);
        insert into oehr_customers values (731,'Margaux','Capshaw','Via Dolorosa 69','361195','Roma',null,'IT','+39 6 012 4539','i','ITALY','2400','Margaux.Capshaw@EIDER.COM',NULL);
        insert into oehr_customers values (754,'Kevin','Goodman','Via Notoriosa 1942','361234','Ventimiglia',null,'IT','+39 10 012 4385','i','ITALY','700','Kevin.Goodman@WIGEON.COM',145);
        insert into oehr_customers values (755,'Kevin','Cleveland','Via Notoriosa 1943','361235','Ventimiglia',null,'IT','+39 10 012 4387','i','ITALY','700','Kevin.Cleveland@WILLET.COM',149);
        insert into oehr_customers values (756,'Kevin','Wilder','Canale Grande 2','361183','Roma',null,'IT','+39 6 012 4389','i','ITALY','700','Kevin.Wilder@AUKLET.COM',149);
        insert into oehr_customers values (757,'Kiefer','Reynolds','Piazza Cacchiatore 23','361184','Roma',null,'IT','+39 6 012 4391','i','ITALY','700','Kiefer.Reynolds@AVOCET.COM',149);
        insert into oehr_customers values (766,'Klaus','Young','Via Del Disegno 194','361223','San Giminiano',null,'IT','+39 49 012 4409','i','ITALY','600','Klaus.Young@OVENBIRD.COM',149);
        insert into oehr_customers values (767,'Klaus Maria','Russell','Piazza Svizzera','361221','San Giminiano',null,'IT','+39 49 012 4411','i','ITALY','100','KlausMaria.Russell@COOT.COM',NULL);
        insert into oehr_customers values (768,'Klaus Maria','MacLaine','Via Dello Croce 93','361227','Tellaro',null,'IT','+39 10 012 4413','i','ITALY','100','KlausMaria.MacLaine@CHUKAR.COM',149);
        insert into oehr_customers values (769,'Kris','Harris','Via Dello Croce 93','361217','San Giminiano',null,'IT','+39 49 012 4415','i','ITALY','400','Kris.Harris@DIPPER.COM',NULL);
        insert into oehr_customers values (770,'Kris','Curtis','Ruella Delle Spiriti','361222','San Giminiano',null,'IT','+39 49 012 4417','i','ITALY','400','Kris.Curtis@DOWITCHER.COM',NULL);
        insert into oehr_customers values (771,'Kris','de Niro','Via Delle Capeletti 52','361224','San Giminiano',null,'IT','+39 49 012 4419','i','ITALY','400','Kris.deNiro@DUNLIN.COM',NULL);
        insert into oehr_customers values (772,'Kristin','Savage','Via Delli Capelli 2','361226','Tellaro',null,'IT','+39 10 012 4421','i','ITALY','400','Kristin.Savage@CURLEW.COM',149);
        insert into oehr_customers values (782,'Laurence','Seignier','1971 Limelight Blvd',null,'Samutprakarn',null,'TH','+66 76 012 4441','th','THAILAND','1200','Laurence.Seignier@CREEPER.COM',149);
        insert into oehr_customers values (825,'Alain','Dreyfuss','Harmoniegasse 3','3413','Baden-Daettwil','AG','CH','+41 56 012 3527','d','SWITZERLAND','500','Alain.Dreyfuss@VEERY.COM',149);
        insert into oehr_customers values (826,'Alain','Barkin','Sonnenberg 4','3413','Baden-Daettwil','AG','CH','+41 57 012 3529','d','SWITZERLAND','500','Alain.Barkin@VERDIN.COM',149);
        insert into oehr_customers values (827,'Alain','Siegel','Alfred E. Neumann-Weg 3','3413','Baden-Daettwil','AG','CH','+41 58 012 3531','d','SWITZERLAND','500','Alain.Siegel@VIREO.COM',149);
        insert into oehr_customers values (828,'Alan','Minnelli','Dr. Herbert Bitto Str 23','3413','Baden-Daettwil','AG','CH','+41 59 012 3533','d','SWITZERLAND','2300','Alan.Minnelli@TANAGER.COM',149);
        insert into oehr_customers values (829,'Alan','Hunter','Taefernstr 4','3413','Baden-Daettwil','AG','CH','+41 60 012 3535','d','SWITZERLAND','2300','Alan.Hunter@TATTLER.COM',149);
        insert into oehr_customers values (830,'Albert','Dutt','Kreuzritterplatz 5','3413','Baden-Daettwil','AG','CH','+41 61 012 3537','d','SWITZERLAND','3500','Albert.Dutt@CURLEW.COM',NULL);
        insert into oehr_customers values (831,'Albert','Bel Geddes','Helebardenweg 5','3413','Baden-Daettwil','AG','CH','+41 62 012 3539','d','SWITZERLAND','3500','Albert.BelGeddes@DIPPER.COM',NULL);
        insert into oehr_customers values (832,'Albert','Spacek','Zum Freundlichen Nachbarn 5','3413','Baden-Daettwil','AG','CH','+41 63 012 3541','d','SWITZERLAND','3500','Albert.Spacek@DOWITCHER.COM',NULL);
        insert into oehr_customers values (833,'Alec','Moranis','Ziegenwiese 3','3413','Baden-Daettwil','AG','CH','+41 64 012 3543','d','SWITZERLAND','3500','Alec.Moranis@DUNLIN.COM',149);
        insert into oehr_customers values (834,'Alec','Idle','Am Waldrand 5','3413','Baden-Daettwil','AG','CH','+41 65 012 3545','d','SWITZERLAND','3500','Alec.Idle@EIDER.COM',NULL);
        insert into oehr_customers values (835,'Alexander','Eastwood','Zur Kantine 9','3413','Baden-Daettwil','AG','CH','+41 66 012 3547','d','SWITZERLAND','1200','Alexander.Eastwood@AVOCET.COM',149);
        insert into oehr_customers values (836,'Alexander','Berenger','Grosse Bahnhostrasse 3','3413','Baden-Daettwil','AG','CH','+41 67 012 3549','d','SWITZERLAND','1200','Alexander.Berenger@BECARD.COM',149);
        insert into oehr_customers values (837,'Alexander','Stanton','Paradeplatz 4','8001','Zuerich','ZH','CH','+41 2 012 3551','d','SWITZERLAND','1200','Alexander.Stanton@AUKLET.COM',149);
        insert into oehr_customers values (838,'Alfred','Nicholson','Badenerstr 1941','8004','Zuerich','ZH','CH','+41 3 012 3553','d','SWITZERLAND','3500','Alfred.Nicholson@CREEPER.COM',149);
        insert into oehr_customers values (839,'Alfred','Johnson','Welschdoerfchen 1941','7001','Chur','ZH','CH','+41 81 012 3555','d','SWITZERLAND','3500','Alfred.Johnson@FLICKER.COM',149);
        insert into oehr_customers values (840,'Ali','Elliott','Le Reduit','7064','Tschiertschen','GR','CH','+41 81 012 3557','d','SWITZERLAND','1400','Ali.Elliott@ANHINGA.COM',NULL);
        insert into oehr_customers values (841,'Ali','Boyer','Bendlehn','9062','Trogen','SG','CH','+41 71 012 3559','d','SWITZERLAND','1400','Ali.Boyer@WILLET.COM',NULL);
        insert into oehr_customers values (842,'Ali','Stern','Spisertor 3','7000','St. Gallen','SG','CH','+41 71 012 3561','d','SWITZERLAND','1400','Ali.Stern@YELLOWTHROAT.COM',149);
        insert into oehr_customers values (843,'Alice','Oates','Langstr 14','8004','Zuerich','ZH','CH','+41 4 012 3563','d','SWITZERLAND','700','Alice.Oates@BECARD.COM',NULL);
        insert into oehr_customers values (844,'Alice','Julius','Roessligasse 4','8001','Zurich','ZH','CH','+41 6 012 3565','d','SWITZERLAND','700','Alice.Julius@BITTERN.COM',NULL);
        insert into oehr_customers values (845,'Ally','Fawcett','Zum Froehlichen Schweizer 3','8000','Zurich','ZH','CH','+41 7 012 3567','d','SWITZERLAND','5000','Ally.Fawcett@PLOVER.COM',NULL);
        insert into oehr_customers values (846,'Ally','Brando','Chrottenweg','3000','Bern','BE','CH','+41 31 012 3569','d','SWITZERLAND','5000','Ally.Brando@PINTAIL.COM',149);
        insert into oehr_customers values (847,'Ally','Streep','Bruppacher Str 3','3413','Baden-Daettwil','AG','CH','+41 68 012 3571','d','SWITZERLAND','5000','Ally.Streep@PIPIT.COM',NULL);
        insert into oehr_customers values (848,'Alonso','Olmos','Limmatquai','8001','Zuerich','ZH','CH','+41 5 012 3573','d','SWITZERLAND','1800','Alonso.Olmos@PHALAROPE.COM',145);
        insert into oehr_customers values (849,'Alonso','Kaurusmdki','Dreikoenigsstr 3','8001','Zurich','ZH','CH','+41 8 012 3575','d','SWITZERLAND','1800','Alonso.Kaurusmdki@PHOEBE.COM',145);
        insert into oehr_customers values (850,'Amanda','Finney','Pfannenstilstr 13','8132','Egg','ZH','CH','+41 1 012 3577','d','SWITZERLAND','2300','Amanda.Finney@STILT.COM',145);
        insert into oehr_customers values (851,'Amanda','Brown','Kreuzstr 32','8032','Zurich','ZH','CH','+41 9 012 3579','d','SWITZERLAND','2300','Amanda.Brown@THRASHER.COM',145);
        insert into oehr_customers values (852,'Amanda','Tanner','1539 Stripes Rd','3413','Baden-Daettwil','AG','CH','+41 69 012 3581','d','SWITZERLAND','2300','Amanda.Tanner@TEAL.COM',145);
        insert into oehr_customers values (853,'Amrish','Palin','1540 Stripes Crt','3413','Baden-Daettwil','AG','CH','+41 70 012 3583','d','SWITZERLAND','400','Amrish.Palin@EIDER.COM',145);
        insert into oehr_customers values (905,'Billy','Hershey','1592 Silverado St','361123','Bangalore','Kar','IN','+91 80 012 3687','hi','INDIA','1400','Billy.Hershey@BULBUL.COM',NULL);
        insert into oehr_customers values (906,'Billy','Dench','1593 Silverado St','361112','Bangalore','Kar','IN','+91 80 012 3689','hi','INDIA','1400','Billy.Dench@CARACARA.COM',149);
        insert into oehr_customers values (909,'Blake','Mastroianni','1596 Commando Blvd','361126','Bangalore','Kar','IN','+91 80 012 3695','hi','INDIA','1200','Blake.Mastroianni@FLICKER.COM',149);
        insert into oehr_customers values (911,'Bo','Dickinson','1598 Legend St','361149','Bangalore','Kar','IN','+91 80 012 3699','hi','INDIA','5000','Bo.Dickinson@TANAGER.COM',149);
        insert into oehr_customers values (912,'Bo','Ashby','1599 Legend Rd','361128','Bangalore','Kar','IN','+91 80 012 3701','hi','INDIA','5000','Bo.Ashby@TATTLER.COM',NULL);
        insert into oehr_customers values (913,'Bob','Sharif','1600 Target Crt','361191','Bangalore','Kar','IN','+91 80 012 3703','hi','INDIA','5000','Bob.Sharif@TEAL.COM',NULL);
        insert into oehr_customers values (916,'Brian','Douglas','1603 Rebel St','361129','Bangalore','Kar','IN','+91 80 012 3709','hi','INDIA','500','Brian.Douglas@AVOCET.COM',149);
        insert into oehr_customers values (917,'Brian','Baldwin','1604 Volunteers Rd','361121','Bangalore','Kar','IN','+91 80 012 3711','hi','INDIA','500','Brian.Baldwin@BECARD.COM',149);
        insert into oehr_customers values (919,'Brooke','Michalkow','1606 Volunteers Blvd','361196','Bangalore','Kar','IN','+91 80 012 3715','hi','INDIA','3500','Brooke.Michalkow@GROSBEAK.COM',NULL);
        insert into oehr_customers values (920,'Bruce','Hulce','1607 Abwdrts St','361114','Bangalore','Kar','IN','+91 80 012 3717','hi','INDIA','3500','Bruce.Hulce@JACANA.COM',NULL);
        insert into oehr_customers values (921,'Bruce','Dunaway','1608 Amadeus St','361198','Bangalore','Kar','IN','+91 80 012 3719','hi','INDIA','3500','Bruce.Dunaway@JUNCO.COM',149);
        insert into oehr_customers values (923,'Bruno','Slater','1610 Betrayal Crt','361119','Bangalore','Kar','IN','+91 80 012 3723','hi','INDIA','5000','Bruno.Slater@THRASHER.COM',149);
        insert into oehr_customers values (924,'Bruno','Montand','1611 Carmen Blvd','361118','Bangalore','Kar','IN','+91 80 012 3725','hi','INDIA','5000','Bruno.Montand@TOWHEE.COM',149);
        insert into oehr_customers values (927,'Bryan','Belushi','1614 Crackers Rd','361168','Bangalore - India','Kar','IN','+91 80 012 3731','hi','INDIA','2300','Bryan.Belushi@TOWHEE.COM',149);
        insert into oehr_customers values (928,'Burt','Spielberg','1615 Crackers Crt','361168','Bangalore - India','Kar','IN','+91 80 012 3733','hi','INDIA','5000','Burt.Spielberg@TROGON.COM',NULL);
        insert into oehr_customers values (929,'Burt','Neeson','1616 Crackers Blvd','361168','Bangalore - India','Kar','IN','+91 80 012 3735','hi','INDIA','5000','Burt.Neeson@TURNSTONE.COM',149);
        insert into oehr_customers values (930,'Buster','Jackson','1617 Crackers St','361168','Bangalore - India','Kar','IN','+91 80 012 3737','hi','INDIA','900','Buster.Jackson@KILLDEER.COM',149);
        insert into oehr_customers values (931,'Buster','Edwards','1618 Footloose St','361168','Bangalore - India','Kar','IN','+91 80 012 3739','hi','INDIA','900','Buster.Edwards@KINGLET.COM',NULL);
        insert into oehr_customers values (932,'Buster','Bogart','1619 Footloose Rd','361168','Bangalore - India','Kar','IN','+91 80 012 3741','hi','INDIA','900','Buster.Bogart@KISKADEE.COM',NULL);
        insert into oehr_customers values (934,'C. Thomas','Nolte','1621 Gargon! Blvd','361168','Bangalore - India','Kar','IN','+91 80 012 3745','hi','INDIA','600','C.Thomas.Nolte@PHOEBE.COM',145);
        insert into oehr_customers values (980,'Daniel','Loren','1667 2010 St','61311','Batavia','IL','IN','+91 80 012 3837','hi','INDIA','200','Daniel.Loren@REDSTART.COM',149);
        insert into oehr_customers values (981,'Daniel','Gueney','1668 Chong Tao','111181','Beijing',null,'CN','+86 10 012 3839','zhs','CHINA','200','Daniel.Gueney@REDPOLL.COM',149); 
        
        update oehr_customers c set account_mgr_id = 147 where c.country_id IN ('CH','DE','IT','CA');
        update oehr_customers c set account_mgr_id = 145 where c.country_id='US' and c.state_province='IA';
        update oehr_customers c set account_mgr_id = 145 where c.country_id='US' and c.state_province='IN';
        update oehr_customers c set account_mgr_id = 145 where c.country_id='US' and c.state_province='MD';
        update oehr_customers c set account_mgr_id = 145 where c.country_id='US' and c.state_province='MI';
        update oehr_customers c set account_mgr_id = 145 where c.country_id='US' and c.state_province='MN';
        update oehr_customers c set account_mgr_id = 149 where c.country_id='US' and c.state_province='NY';
        update oehr_customers c set account_mgr_id = 149 where c.country_id='US' and c.state_province='PA';
        update oehr_customers c set account_mgr_id = 145 where c.country_id='US' and c.state_province='WI';
        update oehr_customers c set account_mgr_id = 148 where c.country_id IN ('CN','IN','JP');
      end;~';
   insert into wwv_sample_dmls (wwv_sample_dataset_id, language_cd, dml_name, install_seq, dml) 
   values (  3, 'en', 'Insert Into customers (Part 2)', 21, l_clob);

   l_clob :=q'~begin
        insert into oehr_product_information values 
        (1726
        , 'LCD Monitor 11/PM'
        , 'Liquid Cristal Display 11 inch passive monitor. The virtually-flat,
        high-resolution screen delivers outstanding image quality with reduced glare.'
        , 11,3
        , to_yminterval('+00-03')
        , 102067
        , 'under development'
        , 259
        , 208
        , 'http://www.www.supp-102067.com/cat/hw/p1726.html');
        
        insert into oehr_product_information values 
        (2359
        , 'LCD Monitor 9/PM'
        , 'Liquid Cristal Display 9 inch passive monitor. Enjoy the productivity that
        a small monitor can bring via more workspace on your desk. Easy setup with
        plug-and-play compatibility.'
        , 11,3
        , to_yminterval('+00-03')
        , 102061
        , 'orderable'
        , 249
        , 206
        , 'http://www.www.supp-102061.com/cat/hw/p2359.html');
        
        insert into oehr_product_information values 
        (3060
        , 'Monitor 17/HR'
        , 'CRT Monitor 17 inch (16 viewable) high resolution. Exceptional image
        performance and the benefit of additional screen space. This monitor offers
        sharp, color-rich monitor performance at an incredible value. With a host of
        leading features, including on-screen display controls.'
        , 11,4
        , to_yminterval('+00-06')
        , 102081
        , 'orderable'
        , 299
        , 250
        , 'http://www.supp-102081.com/cat/hw/p3060.html');
        
        insert into oehr_product_information values 
        (2243
        , 'Monitor 17/HR/F'
        , 'Monitor 17 inch (16 viewable) high resolution, flat screen. High density
        photon gun with Enhanced Elliptical Correction System for more consistent,
        accurate focus across the screen, even in the corners.'
        , 11,4
        , to_yminterval('+00-06')
        , 102060
        , 'orderable'
        , 350
        , 302
        , 'http://www.supp-102060.com/cat/hw/p2243.html');
        
        insert into oehr_product_information values 
        (3057
        , 'Monitor 17/SD'
        , 'CRT Monitor 17 inch (16 viewable) short depth. Delivers outstanding
        image clarity and precision. Gives professional color, technical
        engineering, and visualization/animation users the color fidelity they
        demand, plus a large desktop for enhanced productivity.'
        , 11,4
        , to_yminterval('+00-06')
        , 102055
        , 'orderable'
        , 369
        , 320
        , 'http://www.supp-102055.com/cat/hw/p3057.html');
        
        insert into oehr_product_information values 
        (3061
        , 'Monitor 19/SD'
        , 'CRT Monitor 19 inch (18 viewable) short depth. High-contrast black
        screen coating: produces superior contrast and grayscale performance.
        The newly designed, amplified professional speakers with dynamic bass
        response bring all of your multimedia audio experiences to life with
        crisp, true-to-life sound and rich, deep bass tones. Plus, color-coded
        cables, simple plug-and-play setup and digital on-screen controls mean you
        are ready to set your sights on outrageous multimedia and the incredible
        Internet in just minutes.'
        , 11,5
        , to_yminterval('+00-09')
        , 102094
        , 'orderable'
        , 499
        , 437
        , 'http://www.supp-102094.com/cat/hw/p3061.html');
        
        insert into oehr_product_information values 
        (2245
        , 'Monitor 19/SD/M'
        , 'Monitor 19 (18 Viewable) short depth, Monochrome. Outstanding image
        performance in a compact design. A simple, on-screen dislay menu helps you
        easily adjust screen dimensions, colors and image attributes. Just plug
        your monitor into your PC and you are ready to go.'
        , 11,5
        , to_yminterval('+00-09')
        , 102053
        , 'orderable'
        , 512
        , 420
        , 'http://www.supp-102053.com/cat/hw/p2245.html');
        
        insert into oehr_product_information values 
        (3065
        , 'Monitor 21/D'
        , 'CRT Monitor 21 inch (20 viewable). Digital OptiScan technology: supports
        resolutions up to 1600 x 1200 at 75Hz. Dimensions (HxWxD): 8.3 x 18.5 x 15
        inch. The detachable or attachable monitor-powered Platinum Series speakers
        offer crisp sound and the convenience of a digital audio player jack. Just
        plug in your digital audio player and listen to tunes without powering up
        your PC.'
        , 11,5
        , to_yminterval('+01-00')
        , 102051
        , 'orderable'
        , 999
        , 875
        , 'http://www.supp-102051.com/cat/hw/p3065.html');
        
        insert into oehr_product_information values 
        (3331
        , 'Monitor 21/HR'
        , '21 inch monitor (20 inch viewable) high resolution. This monitor is ideal
        for business, desktop publishing, and graphics-intensive applications. Enjoy
        the productivity that a large monitor can bring via more workspace for
        running applications.'
        , 11,5
        , to_yminterval('+01-00')
        , 102083
        , 'orderable'
        , 879
        , 785
        , 'http://www.supp-102083.com/cat/hw/p3331.html');
        
        insert into oehr_product_information values 
        (2252
        , 'Monitor 21/HR/M'
        , 'Monitor 21 inch (20 viewable) high resolution, monochrome. Unit size:
        35.6 x 29.6 x 33.3 cm (14.6 kg) Package: 40.53 x 31.24 x 35.39 cm
        (16.5 kg). Horizontal frequency 31.5 - 54 kHz, Vertical frequency 50 - 120
        Hz. Universal power supply 90 - 132 V, 50 - 60 Hz.'
        , 11,5
        , to_yminterval('+01-06')
        , 102079
        , 'obsolete'
        , 889
        , 717
        , 'http://www.supp-102079.com/cat/hw/p2252.html');
        
        insert into oehr_product_information values 
        (3064
        , 'Monitor 21/SD'
        , 'Monitor 21 inch (20 viewable) short depth. Features include a 0.25-0.28
        Aperture Grille Pitch, resolution support up to 1920 x 1200 at 76Hz,
        on-screen displays, and a conductive anti-reflective film coating.'
        , 11,5
        , to_yminterval('+01-06')
        , 102096
        , 'planned'
        , 1023
        , 909
        , 'http://www.supp-102096.com/cat/hw/p3064.html');
        
        insert into oehr_product_information values 
        (3155
        , 'Monitor Hinge - HD'
        , 'Monitor Hinge, heavy duty, maximum monitor weight 30 kg'
        , 11,4
        , to_yminterval('+10-00')
        , 102092
        , 'orderable'
        , 49
        , 42
        , 'http://www.supp-102092.com/cat/hw/p3155.html');
        
        insert into oehr_product_information values 
        (3234
        , 'Monitor Hinge - STD'
        , 'Standard Monitor Hinge, maximum monitor weight 10 kg'
        , 11,3
        , to_yminterval('+10-00')
        , 102072
        , 'orderable'
        , 39
        , 34
        , 'http://www.supp-102072.com/cat/hw/p3234.html');
        
        insert into oehr_product_information values 
        (3350
        , 'Plasma Monitor 10/LE/VGA'
        , '10 inch low energy plasma monitor, VGA resolution'
        , 11,3
        , to_yminterval('+01-00')
        , 102068
        , 'orderable'
        , 740
        , 630
        , 'http://www.supp-102068.com/cat/hw/p3350.html');
        
        insert into oehr_product_information values 
        (2236
        , 'Plasma Monitor 10/TFT/XGA'
        , '10 inch TFT XGA flatscreen monitor for laptop computers'
        , 11,3
        , to_yminterval('+01-00')
        , 102090
        , 'under development'
        , 964
        , 863
        , 'http://www.supp-102090.com/cat/hw/p2236.html');
        
        insert into oehr_product_information values 
        (3054
        , 'Plasma Monitor 10/XGA'
        , '10 inch standard plasma monitor, XGA resolution. This virtually-flat,
        high-resolution screen delivers outstanding image quality with reduced glare.'
        , 11,3
        , to_yminterval('+01-00')
        , 102060
        , 'orderable'
        , 600
        , 519
        , 'http://www.supp-102060.com/cat/hw/p3054.html');
        
        insert into oehr_product_information values 
        (1782
        , 'Compact 400/DQ'
        , '400 characters per second high-speed draft printer. Dimensions (HxWxD):
        17.34 x 24.26 x 26.32 inch. Interface: RS-232 serial (9-pin), no expansion
        slots. Paper size: A4, US Letter.'
        , 12,4
        , to_yminterval('+01-06')
        , 102088
        , 'obsolete'
        , 125
        , 108
        , 'http://www.supp-102088.com/cat/hw/p1782.html');
        
        insert into oehr_product_information values 
        (2430
        , 'Compact 400/LQ'
        , '400 characters per second high-speed letter-quality printer.
        Dimensions (HxWxD): 12.37 x 27.96 x 23.92 inch. Interface: RS-232 serial
        (25-pin), 3 expansion slots. Paper size: A2, A3, A4.'
        , 12,4
        , to_yminterval('+02-00')
        , 102087
        , 'orderable'
        , 175
        , 143
        , 'http://www.supp-102087.com/cat/hw/p2430.html');
        
        insert into oehr_product_information values 
        (1792
        , 'Industrial 600/DQ'
        , 'Wide carriage color capability 600 characters per second high-speed
        draft printer. Dimensions (HxWxD): 22.31 x 25.73 x 20.12 inch. Paper size:
        3x5 inch to 11x17 inch full bleed wide format.'
        , 12,4
        , to_yminterval('+05-00')
        , 102088
        , 'orderable'
        , 225
        , 180
        , 'http://www.supp-102088.com/cat/hw/p1792.html');
        
        insert into oehr_product_information values 
        (1791
        , 'Industrial 700/HD'
        , '700 characters per second dot-matrix printer with harder body and dust
        protection for industrial uses. Interface: Centronics parallel, IEEE 1284
        compliant. Paper size: 3x5 inch to 11x17 inch full bleed wide format.
        Memory: 4MB. Dimensions (HxWxD): 9.3 x 16.5 x 13 inch.'
        , 12,5
        , to_yminterval('+05-00')
        , 102086
        , 'orderable'
        , 275
        , 239
        , 'http://www.supp-102086.com/cat/hw/p1791.html');
        
        insert into oehr_product_information values 
        (2302
        , 'Inkjet B/6'
        , 'Inkjet Printer, black and white, 6 pages per minute, resolution 600x300
        dpi. Interface: Centronics parallel, IEEE 1284 compliant. Dimensions
        (HxWxD): 7.3 x 17.5 x 14 inch. Paper size: A3, A4, US legal. No
        expansion slots.'
        , 12,3
        , to_yminterval('+02-00')
        , 102096
        , 'orderable'
        , 150
        , 121
        , 'http://www.supp-102096.com/cat/hw/p2302.html');
        
        insert into oehr_product_information values 
        (2453
        , 'Inkjet C/4'
        , 'Inkjet Printer, color (with two separate ink cartridges), 6 pages per
        minute black and white, 4 pages per minute color, resolution 600x300 dpi.
        Interface: Biodirectional IEEE 1284 compliant parallel interface and
        RS-232 serial (9-pin) interface 2 open EIO expansion slots. Memory:
        8MB 96KB receiver buffer.'
        , 12,3
        , to_yminterval('+02-00')
        , 102090
        , 'orderable'
        , 195
        , 174
        , 'http://www.supp-102090.com/cat/hw/p2453.html');
        
        insert into oehr_product_information values 
        (1797
        , 'Inkjet C/8/HQ'
        , 'Inkjet printer, color, 8 pages per minute, high resolution (photo
        quality). Memory: 16MB. Dimensions (HxWxD): 7.3 x 17.5 x 14 inch. Paper
        size: A4, US Letter, envelopes. Interface: Centronics parallel, IEEE
        1284 compliant.'
        , 12,3
        , to_yminterval('+02-00')
        , 102094
        , 'orderable'
        , 349
        , 288
        , 'http://www.supp-102094.com/cat/hw/p1797.html');
        
        insert into oehr_product_information values 
        (2459
        , 'LaserPro 1200/8/BW'
        , 'Professional black and white laserprinter, resolution 1200 dpi, 8 pages
        per second. Dimensions (HxWxD): 22.37 x 19.86 x 21.92 inch. Software:
        Enhanced driver support for SPNIX v4.0; MS-DOS Built-in printer drivers:
        ZoomSmart scaling technology, billboard, handout, mirror, watermark, print
        preview, quick sets, emulate laserprinter margins.'
        , 12,5
        , to_yminterval('+03-00')
        , 102099
        , 'under development'
        , 699
        , 568
        , 'http://www.supp-102099.com/cat/hw/p2459.html');
        
        insert into oehr_product_information values 
        (3127
        , 'LaserPro 600/6/BW'
        , 'Standard black and white laserprinter, resolution 600 dpi, 6 pages per
        second. Interface: Centronics parallel, IEEE 1284 compliant. Memory: 8MB
        96KB receiver buffer. MS-DOS ToolBox utilities for SPNIX AutoCAM v.17
        compatible driver.'
        , 12,4
        , to_yminterval('+03-00')
        , 102087
        , 'orderable'
        , 498
        , 444
        , 'http://www.supp-102087.com/cat/hw/p3127.html');
        
        insert into oehr_product_information values 
        (2254
        , 'HD 10GB /I'
        , '10GB capacity hard disk drive (internal). These drives are intended for
        use in today''s demanding, data-critical enterprise environments and are
        ideal for use in RAID applications. Universal option kits are configured
        and pre-mounted in the appropriate hot plug tray for immediate installation
        into your corporate server or storage system.'
        , 13,2
        , to_yminterval('+02-00')
        , 102071
        , 'obsolete'
        , 453
        , 371
        , 'http://www.supp-102071.com/cat/hw/p2254.html');
        
        insert into oehr_product_information values 
        (3353
        , 'HD 10GB /R'
        , '10GB Removable hard disk drive for 10GB Removable HD drive. Supra7
        disk drives provide the latest technology to improve enterprise
        performance, increasing the maximum data transfer rate up to 160MB/s.'
        , 13,1
        , to_yminterval('+03-00')
        , 102071
        , 'obsolete'
        , 489
        , 413
        , 'http://www.supp-102071.com/cat/hw/p3353.html');
        
        insert into oehr_product_information values 
        (3069
        , 'HD 10GB /S'
        , '10GB hard disk drive for Standard Mount. Backward compatible with
        Supra5 systems, users are free to deploy and re-deploy these drives to
        quickly deliver increased storage capacity. Supra drives eliminate the
        risk of firmware incompatibility.'
        , 13,1
        , to_yminterval('+02-00')
        , 102051
        , 'obsolete'
        , 436
        , 350
        , 'http://www.supp-102051.com/cat/hw/p3069.html');
        
        insert into oehr_product_information values 
        (2253
        , 'HD 10GB @5400 /SE'
        , '10GB capacity hard disk drive (external) SCSI interface, 5400 RPM.
        Universal option kits are configured and pre-mounted in the appropriate
        hot plug tray for immediate installation into your corporate server or
        storage system. Supra drives eliminate the risk of firmware incompatibility.'
        , 13,2
        , to_yminterval('+03-00')
        , 102069
        , 'obsolete'
        , 399
        , 322
        , 'http://www.supp-102069.com/cat/hw/p2253.html');
        
        insert into oehr_product_information values 
        (3354
        , 'HD 12GB /I'
        , '12GB capacity harddisk drive (internal). Supra drives eliminate the risk
        of firmware incompatibility. Backward compatibility: You can mix or
        match Supra2 and Supra3 devices for optimized solutions and future growth.'
        , 13,2
        , to_yminterval('+02-00')
        , 102066
        , 'orderable'
        , 543
        , 478
        , 'http://www.supp-102066.com/cat/hw/p3354.html');
        
        insert into oehr_product_information values 
        (3072
        , 'HD 12GB /N'
        , '12GB hard disk drive for Narrow Mount. Supra9 hot pluggable hard disk
        drives provide the ability to install or remove drives on-line. Our hot
        pluggable hard disk drives are required to meet our rigorous standards
        for reliability and performance.'
        , 13,1
        , to_yminterval('+03-00')
        , 102061
        , 'orderable'
        , 567
        , 507
        , 'http://www.supp-102061.com/cat/hw/p3072.html');
        
        insert into oehr_product_information values 
        (3334
        , 'HD 12GB /R'
        , '12GB Removable hard disk drive. With compatibility across many enterprise
        platforms, you are free to deploy and re-deploy this drive to quickly
        deliver increased storage capacity. Supra7 Universal disk drives are the
        second generation of high performance hot plug drives sharing compatibility
        across corporate servers and external storage enclosures.'
        , 13,2
        , to_yminterval('+03-00')
        , 102090
        , 'orderable'
        , 612
        , 512
        , 'http://www.supp-102090.com/cat/hw/p3334.html');
        
        insert into oehr_product_information values 
        (3071
        , 'HD 12GB /S'
        , '12GB hard disk drive for Standard Mount. Supra9 hot pluggable hard disk
        drives provide the ability to install or remove drives on-line. Our hot
        pluggable hard disk drives are required to meet our rigorous standards
        for reliability and performance.'
        , 13,1
        , to_yminterval('+03-00')
        , 102071
        , 'orderable'
        , 633
        , 553
        , 'http://www.supp-102071.com/cat/hw/p3071.html');
        
        insert into oehr_product_information values 
        (2255
        , 'HD 12GB @7200 /SE'
        , '12GB capacity hard disk drive (external) SCSI, 7200 RPM. These drives
        are intended for use in today''s demanding, data-critical enterprise
        environments and can be used in RAID applications. Universal option kits
        are configured and pre-mounted in the appropriate hot plug tray for
        immediate installation into your corporate server or storage system.'
        , 13,2
        , to_yminterval('+02-00')
        , 102057
        , 'orderable'
        , 775
        , 628
        , 'http://www.supp-102057.com/cat/hw/p2255.html');
        
        insert into oehr_product_information values 
        (1743
        , 'HD 18.2GB @10000 /E'
        , 'External hard drive disk - 18.2 GB, rated up to 10,000 RPM. These
        drives are intended for use in today''s demanding, data-critical
        enterprise environments and are ideal for use in RAID applications.'
        , 13,3
        , to_yminterval('+03-00')
        , 102078
        , 'planned'
        , 800
        , 661
        , 'http://www.supp-102078.com/cat/hw/p1743.html');
        
        insert into oehr_product_information values 
        (2382
        , 'HD 18.2GB@10000 /I'
        , '18.2 GB SCSI hard disk @ 10000 RPM (internal). Supra7 Universal
        disk drives provide an unequaled level of investment protection and
        simplification for customers by enabling drive compatibility across
        many enterprise platforms.'
        , 13,3
        , to_yminterval('+03-00')
        , 102050
        , 'under development'
        , 850
        , 731
        , 'http://www.supp-102050.com/cat/hw/p2382.html');
        
        insert into oehr_product_information values 
        (3399
        , 'HD 18GB /SE'
        , '18GB SCSI external hard disk drive. Supra5 Universal hard disk
        drives provide the ability to hot plug between various servers, RAID
        arrays, and external storage shelves.'
        , 13,3
        , to_yminterval('+02-00')
        , 102083
        , 'under development'
        , 815
        , 706
        , 'http://www.supp-999999.com/cat/hw/p3333.html');
        
        insert into oehr_product_information values 
        (3073
        , 'HD 6GB /I'
        , '6GB capacity hard disk drive (internal). Supra drives eliminate the
        risk of firmware incompatibility.'
        , 13,2
        , to_yminterval('+05-00')
        , 102072
        , 'obsolete'
        , 224
        , 197
        , 'http://www.supp-102083.com/cat/hw/p3073.html');
        
        insert into oehr_product_information values 
        (1768
        , 'HD 8.2GB @5400'
        , 'Hard drive disk - 8.2 GB, rated up to 5,400 RPM. Supra drives
        eliminate the risk of firmware incompatibility. Standard serial
        RS-232 interface.'
        , 13,2
        , to_yminterval('+02-00')
        , 102093
        , 'orderable'
        , 345
        , 306
        , 'http://www.supp-102093.com/cat/hw/p1768.html');
        
        insert into oehr_product_information values 
        (2410
        , 'HD 8.4GB @5400'
        , '8.4 GB hard disk @ 5400 RPM. Reduced cost of ownership: Drives can
        be utilized across enterprise platforms. This hot pluggable hard disk
        drive is required to meet your rigorous standards for reliability
        and performance.'
        , 13,2
        , to_yminterval('+03-00')
        , 102061
        , 'orderable'
        , 357
        , 319
        , 'http://www.supp-102061.com/cat/hw/p2410.html');
        
        insert into oehr_product_information values 
        (2257
        , 'HD 8GB /I'
        , '8GB capacity hard disk drive (internal). Supra9 hot pluggable
        hard disk drives provide the ability to install or remove drives
        on-line. Backward compatibility: You can mix Supra2 and Supra3
        devices for optimized solutions and future growth.'
        , 13,1
        , to_yminterval('+03-00')
        , 102061
        , 'orderable'
        , 399
        , 338
        , 'http://www.supp-102061.com/cat/hw/p2257.html');
        
        insert into oehr_product_information values 
        (3400
        , 'HD 8GB /SE'
        , '8GB capacity SCSI hard disk drive (external). Supra7 disk drives
        provide the latest technology to improve enterprise performance,
        increasing the maximum data transfer rate up to 255MB/s.'
        , 13,2
        , to_yminterval('+03-00')
        , 102063
        , 'orderable'
        , 389
        , 337
        , 'http://www.supp-102063.com/cat/hw/p3400.html');
        
        insert into oehr_product_information values 
        (3355
        , 'HD 8GB /SI'
        , '8GB SCSI hard disk drive, internal. With compatibility across many
        enterprise platforms, you are free to deploy and re-deploy this drive
        to quickly deliver increased storage capacity. '
        , 13,1
        , to_yminterval('+02-00')
        , 102050
        , 'orderable'
        , NULL
        , NULL
        , 'http://www.supp-102050.com/cat/hw/p3355.html');
        
        insert into oehr_product_information values 
        (1772
        , 'HD 9.1GB @10000'
        , 'Hard disk drive - 9.1 GB, rated up to 10,000 RPM. These drives
        are intended for use in data-critical enterprise environments.
        Ease of doing business: you can easily select the drives you need
        regardless of the application in which they will be deployed.'
        , 13,3
        , to_yminterval('+05-00')
        , 102070
        , 'orderable'
        , 456
        , 393
        , 'http://www.supp-102070.com/cat/hw/p1772.html');
        
        insert into oehr_product_information values 
        (2414
        , 'HD 9.1GB @10000 /I'
        , '9.1 GB SCSI hard disk @ 10000 RPM (internal). Supra7 disk
        drives are available in 10,000 RPM spindle speeds and capacities
        of 18GB and 9.1 GB. SCSI and RS-232 interfaces.'
        , 13,3
        , to_yminterval('+05-00')
        , 102098
        , 'orderable'
        , 454
        , 399
        , 'http://www.supp-102098.com/cat/hw/p2414.html');
        
        insert into oehr_product_information values 
        (2415
        , 'HD 9.1GB @7200'
        , '9.1 GB hard disk @ 7200 RPM. Universal option kits are
        configured and pre-mounted in the appropriate hot plug tray
        for immediate installation into your corporate server or storage
        system.'
        , 13,3
        , to_yminterval('+05-00')
        , 102063
        , 'orderable'
        , 359
        , 309
        , 'http://www.supp-102063.com/cat/hw/p2415.html');
        
        insert into oehr_product_information values 
        (2395
        , '32MB Cache /M'
        , '32MB Mirrored cache memory (100-MHz Registered SDRAM)'
        , 14,1
        , to_yminterval('+00-06')
        , 102093
        , 'orderable'
        , 123
        , 109
        , 'http://www.supp-102093.com/cat/hw/p2395.html');
        
        insert into oehr_product_information values 
        (1755
        , '32MB Cache /NM'
        , '32MB Non-Mirrored cache memory'
        , 14,1
        , to_yminterval('+00-06')
        , 102076
        , 'orderable'
        , 121
        , 99
        , 'http://www.supp-102076.com/cat/hw/p1755.html');
        
        insert into oehr_product_information values 
        (2406
        , '64MB Cache /M'
        , '64MB Mirrored cache memory'
        , 14,1
        , to_yminterval('+00-06')
        , 102059
        , 'orderable'
        , 223
        , 178
        , 'http://www.supp-102059.com/cat/hw/p2406.html');
        
        insert into oehr_product_information values 
        (2404
        , '64MB Cache /NM'
        , '64 MB Non-mirrored cache memory. FPM memory chips are
        implemented on 5 volt SIMMs, but are also available on
        3.3 volt DIMMs.'
        , 14,1
        , to_yminterval('+00-06')
        , 102087
        , 'orderable'
        , 221
        , 180
        , 'http://www.supp-102087.com/cat/hw/p2404.html');
        
        insert into oehr_product_information values 
        (1770
        , '8MB Cache /NM'
        , '8MB Non-Mirrored Cache Memory (100-MHz Registered SDRAM)'
        , 14,1
        , to_yminterval('+00-06')
        , 102050
        , 'orderable'
        , NULL
        , 73
        , 'http://www.supp-102050.com/cat/hw/p1770.html');
        
        insert into oehr_product_information values 
        (2412
        , '8MB EDO Memory'
        , '8 MB 8x32 EDO SIM memory. Extended Data Out memory differs from FPM in a
        small, but significant design change. Unlike FPM, the data output drivers
        for EDO remain on when the memory controller removes the column address to
        begin the next cycle. Therefore, a new data cycle can begin before the
        previous cycle has completed. EDO is available on SIMMs and DIMMs, in 3.3
        and 5 volt varieties.'
        , 14,1
        , to_yminterval('+00-06')
        , 102058
        , 'obsolete'
        , 98
        , 83
        , 'http://www.supp-102058.com/cat/hw/p2412.html');
        
        insert into oehr_product_information values 
        (2378
        , 'DIMM - 128 MB'
        , '128 MB DIMM memory. The main reason for the change from SIMMs to DIMMs is
        to support the higher bus widths of 64-bit processors. DIMMs are 64- or
        72-bits wide; SIMMs are only 32- or 36-bits wide (with parity).'
        , 14,1
        , to_yminterval('+00-06')
        , 102050
        , 'orderable'
        , 305
        , 247
        , 'http://www.supp-102050.com/cat/hw/p2378.html');
        
        insert into oehr_product_information values 
        (3087
        , 'DIMM - 16 MB'
        , 'Citrus OLX DIMM - 16 MB capacity.'
        , 14,1
        , to_yminterval('+00-06')
        , 102081
        , 'obsolete'
        , 124
        , 99
        , 'http://www.supp-102081.com/cat/hw/p3087.html');
        
        insert into oehr_product_information values 
        (2384
        , 'DIMM - 1GB'
        , 'Memory DIMM: RAM - 1 GB capacity.'
        , 14,1
        , to_yminterval('+00-06')
        , 102074
        , 'under development'
        , 599
        , 479
        , 'http://www.supp-102074.com/cat/hw/p2384.html');
        
        insert into oehr_product_information values 
        (1749
        , 'DIMM - 256MB'
        , 'Memory DIMM: RAM 256 MB. (100-MHz Registered SDRAM)'
        , 14,1
        , to_yminterval('+00-06')
        , 102053
        , 'orderable'
        , 337
        , 300
        , 'http://www.supp-102053.com/cat/hw/p1749.html');
        
        insert into oehr_product_information values 
        (1750
        , 'DIMM - 2GB'
        , 'Memory DIMM: RAM, 2 GB capacity.'
        , 14,1
        , to_yminterval('+00-06')
        , 102052
        , 'orderable'
        , 699
        , 560
        , 'http://www.supp-102052.com/cat/hw/p1750.html');
        
        insert into oehr_product_information values 
        (2394
        , 'DIMM - 32MB'
        , '32 MB DIMM Memory upgrade'
        , 14,1
        , to_yminterval('+00-06')
        , 102054
        , 'orderable'
        , 128
        , 106
        , 'http://www.supp-102054.com/cat/hw/p2394.html');
        
        insert into oehr_product_information values 
        (2400
        , 'DIMM - 512 MB'
        , '512 MB DIMM memory. Improved memory upgrade granularity: Fewer DIMMs are
        required to upgrade a system than it would require if using SIMMs in the same
        system. Increased maximum memory ceilings: Given the same number of memory
        slots, the maximum memory of a system using DIMMs is more than one using
        SIMMs. DIMMs have separate contacts on each side of the board, which provide
        two times the data rate as one SIMM.'
        , 14,1
        , to_yminterval('+01-00')
        , 102098
        , 'under development'
        , 448
        , 380
        , 'http://www.supp-102098.com/cat/hw/p2400.html');
        
        insert into oehr_product_information values 
        (1763
        , 'DIMM - 64MB'
        , 'Memory DIMM: RAM, 64MB (100-MHz Unregistered ECC SDRAM)'
        , 14,1
        , to_yminterval('+01-00')
        , 102069
        , 'orderable'
        , 247
        , 202
        , 'http://www.supp-102069.com/cat/hw/p1763.html');
        
        insert into oehr_product_information values 
        (2396
        , 'EDO - 32MB'
        , 'Memory EDO SIM: RAM, 32 MB (100-MHz Unregistered ECC SDRAM). Like FPM,
        EDO is available on SIMMs and DIMMs, in 3.3 and 5 volt varieties If EDO
        memory is installed in a computer that was not designed to support it,
        the memory may not work.'
        , 14,1
        , to_yminterval('+00-06')
        , 102051
        , 'orderable'
        , 179
        , 149
        , 'http://www.supp-102051.com/cat/hw/p2396.html');
        
        insert into oehr_product_information values 
        (2272
        , 'RAM - 16 MB'
        , 'Memory SIMM: RAM - 16 MB capacity.'
        , 14,1
        , to_yminterval('+01-00')
        , 102074
        , 'obsolete'
        , 135
        , 110
        , 'http://www.supp-102074.com/cat/hw/p2272.html');
        
        insert into oehr_product_information values 
        (2274
        , 'RAM - 32 MB'
        , 'Memory SIMM: RAM - 32 MB capacity.'
        , 14,1
        , to_yminterval('+01-00')
        , 102064
        , 'orderable'
        , 161
        , 135
        , 'http://www.supp-102064.com/cat/hw/p2274.html');
        
        insert into oehr_product_information values 
        (3090
        , 'RAM - 48 MB'
        , 'Random Access Memory, SIMM - 48 MB capacity.'
        , 14,1
        , to_yminterval('+01-00')
        , 102084
        , 'orderable'
        , 193
        , 170
        , 'http://www.supp-102084.com/cat/hw/p3090.html');
      end;~';
   insert into wwv_sample_dmls (wwv_sample_dataset_id, language_cd, dml_name, install_seq, dml) 
   values (  3, 'en', 'Insert Into product information (Part 1)', 30, l_clob);

   l_clob :=q'~begin        
        insert into oehr_product_information values 
        (1739
        , 'SDRAM - 128 MB'
        , 'SDRAM memory, 128 MB capacity. SDRAM can access data at speeds up to 100
        MHz, which is up to four times as fast as standard DRAMs. The advantages of
        SDRAM can be fully realized, however, only by computers designed to support
        SDRAM. SDRAM is available on 5 and 3.3 volt DIMMs.'
        , 14,1
        , to_yminterval('+00-09')
        , 102077
        , 'orderable'
        , 299
        , 248
        , 'http://www.supp-102077.com/cat/hw/p1739.html');
        
        insert into oehr_product_information values 
        (3359
        , 'SDRAM - 16 MB'
        , 'SDRAM memory upgrade module, 16 MB. Synchronous Dynamic Random Access
        Memory was introduced after EDO. Its architecture and operation are based on
        those of the standard DRAM, but SDRAM provides a revolutionary change to main
        memory that further reduces data retrieval times. SDRAM is synchronized to
        the system clock that controls the CPU. This means that the system clock
        controlling the functions of the microprocessor also controls the SDRAM
        functions. This enables the memory controller to know on which clock cycle
        a data request will be ready, and therefore eliminates timing delays.'
        , 14,1
        , to_yminterval('+00-09')
        , 102059
        , 'orderable'
        , 111
        , 99
        , 'http://www.supp-102059.com/cat/hw/p3359.html');
        
        insert into oehr_product_information values 
        (3088
        , 'SDRAM - 32 MB'
        , 'SDRAM module with ECC - 32 MB capacity. SDRAM has multiple memory banks
        that can work simultaneously. Switching between banks allows for a
        continuous data flow.'
        , 14,1
        , to_yminterval('+00-09')
        , 102057
        , 'orderable'
        , 258
        , 220
        , 'http://www.supp-102057.com/cat/hw/p3088.html');
        
        insert into oehr_product_information values 
        (2276
        , 'SDRAM - 48 MB'
        , 'Memory SIMM: RAM - 48 MB. SDRAM can operate in burst mode. In burst
        mode, when a single data address is accessed, an entire block of data is
        retrieved rather than just the one piece. The assumption is that the next
        piece of data that will be requested will be sequential to the previous.
        Since this is usually the case, data is held readily available.'
        , 14,1
        , to_yminterval('+00-09')
        , 102058
        , 'orderable'
        , 269
        , 215
        , 'http://www.supp-102058.com/cat/hw/p2276.html');
        
        insert into oehr_product_information values 
        (3086
        , 'VRAM - 16 MB'
        , 'Citrus Video RAM module - 16 MB capacity. VRAM is used by the video system
        in a computer to store video information and is reserved exclusively for
        video operations. It was developed to provide continuous streams of serial
        data for refreshing video screens.'
        , 14,1
        , to_yminterval('+00-06')
        , 102056
        , 'orderable'
        , 211
        , 186
        , 'http://www.supp-102056.com/cat/hw/p3086.html');
        
        insert into oehr_product_information values 
        (3091
        , 'VRAM - 64 MB'
        , 'Citrus Video RAM memory module - 64 MB capacity. Physically, VRAM looks
        just like DRAM with added hardware called a shift register. The special
        feature of VRAM is that it can transfer one entire row of data (up to 256
        bits) into this shift register in a single clock cycle. This ability
        significantly reduces retrieval time, since the number of fetches is reduced
        from a possible 256 to a single fetch. The main benefit of having a shift
        register available for data dumps is that it frees the CPU to refresh the
        screen rather than retrieve data, thereby doubling the data bandwidth. For
        this reason, VRAM is often referred to as being dual-ported. However, the
        shift register will only be used when the VRAM chip is given special
        instructions to do so. The command to use the shift register is built into
        the graphics controller.'
        , 14,1
        , to_yminterval('+00-06')
        , 102098
        , 'orderable'
        , 279
        , 243
        , 'http://www.supp-102098.com/cat/hw/p3091.html');
        
        insert into oehr_product_information values 
        (1787
        , 'CPU D300'
        , 'Dual CPU @ 300Mhz. For light personal processing only, or file servers
        with less than 5 concurrent users. This product will probably become
        obsolete soon.'
        , 15,1
        , to_yminterval('+03-00')
        , 102097
        , 'orderable'
        , 101
        , 90
        , 'http://www.supp-102097.com/cat/hw/p1787.html');
        
        insert into oehr_product_information values 
        (2439
        , 'CPU D400'
        , 'Dual CPU @ 400Mhz. Good price/performance ratio; for mid-size LAN
        file servers (up to 100 concurrent users).'
        , 15,1
        , to_yminterval('+03-00')
        , 102092
        , 'orderable'
        , 123
        , 105
        , 'http://www.supp-102092.com/cat/hw/p2439.html');
        
        insert into oehr_product_information values 
        (1788
        , 'CPU D600'
        , 'Dual CPU @ 600Mhz. State of the art, high clock speed; for heavy
        load WAN servers (up to 200 concurrent users).'
        , 15,1
        , to_yminterval('+05-00')
        , 102067
        , 'orderable'
        , 178
        , 149
        , 'http://www.supp-102067.com/cat/hw/p1788.html');
        
        insert into oehr_product_information values 
        (2375
        , 'GP 1024x768'
        , 'Graphics Processor, resolution 1024 X 768 pixels. Outstanding
        price/performance for 2D and 3D applications under SPNIX v3.3 and
        v4.0. Double your viewing power by running two monitors from this
        single card. Two 17 inch monitors have more screen area than one
        21 inch monitor. Excellent option for users that multi-task
        frequently or access data from multiple sources often.'
        , 15,1
        , to_yminterval('+00-09')
        , 102063
        , 'orderable'
        , 78
        , 69
        , 'http://www.supp-102063.com/cat/hw/p2375.html');
        
        insert into oehr_product_information values 
        (2411
        , 'GP 1280x1024'
        , 'Graphics Processor, resolution 1280 X 1024 pixels. High end 3D performance
        at a mid range price: 15 million Gouraud shaded triangles per second,
        Optimized 3D drivers for MCAD and DCC applications, with user-customizable
        settings. 64MB DDR SDRAM unified frame buffer supporting true color at all
        supported standard resolutions.'
        , 15,1
        , to_yminterval('+01-00')
        , 102061
        , 'orderable'
        , 98
        , 78
        , 'http://www.supp-102061.com/cat/hw/p2411.html');
        
        insert into oehr_product_information values 
        (1769
        , 'GP 800x600'
        , 'Graphics processor, resolution 800 x 600 pixels. Remarkable value for
        users requiring great 2D capabilities or general 3D support for advanced
        applications. Drives incredible performance in highly complex models and
        frees the customer to focus on the design, instead of the rendering process.'
        , 15,1
        , to_yminterval('+00-06')
        , 102050
        , 'orderable'
        , 48
        , NULL
        , 'http://www.supp-102050.com/cat/hw/p1769.html');
        
        insert into oehr_product_information values 
        (2049
        , 'MB - S300'
        , 'PC type motherboard, 300 Series.'
        , 15,2
        , to_yminterval('+01-00')
        , 102082
        , 'obsolete'
        , 55
        , 47
        , 'http://www.supp-102082.com/cat/hw/p2049.html');
        
        insert into oehr_product_information values 
        (2751
        , 'MB - S450'
        , 'PC type motherboard, 450 Series.'
        , 15,2
        , to_yminterval('+01-00')
        , 102072
        , 'orderable'
        , 66
        , 54
        , 'http://www.supp-102072.com/cat/hw/p2751.html');
        
        insert into oehr_product_information values 
        (3112
        , 'MB - S500'
        , 'PC type motherboard, 500 Series.'
        , 15,2
        , to_yminterval('+01-06')
        , 102086
        , 'orderable'
        , 77
        , 66
        , 'http://www.supp-102086.com/cat/hw/p3112.html');
        
        insert into oehr_product_information values 
        (2752
        , 'MB - S550'
        , 'PC type motherboard for the 550 Series.'
        , 15,2
        , to_yminterval('+01-06')
        , 102086
        , 'orderable'
        , 88
        , 76
        , 'http://www.supp-102086.com/cat/hw/p2752.html');
        
        insert into oehr_product_information values 
        (2293
        , 'MB - S600'
        , 'Motherboard, 600 Series.'
        , 15,2
        , to_yminterval('+02-00')
        , 102086
        , 'orderable'
        , 99
        , 87
        , 'http://www.supp-102086.com/cat/hw/p2293.html');
        
        insert into oehr_product_information values 
        (3114
        , 'MB - S900/650+'
        , 'PC motherboard, 900 Series; standard motherboard
        for all models 650 and up.'
        , 15,3
        , to_yminterval('+00-00')
        , 102086
        , 'under development'
        , 101
        , 88
        , 'http://www.supp-102086.com/cat/hw/p3114.html');
        
        insert into oehr_product_information values 
        (3129
        , 'Sound Card STD'
        , 'Sound Card - standard version, with MIDI interface,
        line in/out, low impedance microphone input.'
        , 15,1
        , to_yminterval('+00-06')
        , 102090
        , 'orderable'
        , 46
        , 39
        , 'http://www.supp-102090.com/cat/hw/p3129.html');
        
        insert into oehr_product_information values 
        (3133
        , 'Video Card /32'
        , 'Video Card, with 32MB cache memory.'
        , 15,2
        , to_yminterval('+00-06')
        , 102076
        , 'orderable'
        , 48
        , 41
        , 'http://www.supp-102076.com/cat/hw/p3133.html');
        
        insert into oehr_product_information values 
        (2308
        , 'Video Card /E32'
        , '3-D ELSA Video Card, with 32 MB memory.'
        , 15,2
        , to_yminterval('+00-06')
        , 102087
        , 'orderable'
        , 58
        , 48
        , 'http://www.supp-102087.com/cat/hw/p2308.html');
        
        insert into oehr_product_information values 
        (2496
        , 'WSP DA-130'
        , 'Wide storage processor DA-130 for storage subunits.'
        , 15,2
        , to_yminterval('+00-00')
        , 102067
        , 'planned'
        , 299
        , 244
        , 'http://www.supp-102067.com/cat/hw/p2496.html');
        
        insert into oehr_product_information values 
        (2497
        , 'WSP DA-290'
        , 'Wide storage processor (model DA-290).'
        , 15,3
        , to_yminterval('+00-00')
        , 102053
        , 'planned'
        , 399
        , 355
        , 'http://www.supp-102053.com/cat/hw/p2497.html');
        
        insert into oehr_product_information values 
        (3106
        , 'KB 101/EN'
        , 'Standard PC/AT Enhanced Keyboard (101/102-Key).
        Input locale: English (US).'
        , 16,1
        , to_yminterval('+01-00')
        , 102066
        , 'orderable'
        , 48
        , 41
        , 'http://www.supp-102066.com/cat/hw/p3106.html');
        
        insert into oehr_product_information values 
        (2289
        , 'KB 101/ES'
        , 'Standard PC/AT Enhanced Keyboard (101/102-Key).
        Input locale: Spanish.'
        , 16,1
        , to_yminterval('+01-00')
        , 102055
        , 'orderable'
        , 48
        , 38
        , 'http://www.supp-102055.com/cat/hw/p2289.html');
        
        insert into oehr_product_information values 
        (3110
        , 'KB 101/FR'
        , 'Standard PC/AT Enhanced Keyboard (101/102-Key).
        Input locale: French.'
        , 16,1
        , to_yminterval('+01-00')
        , 102055
        , 'orderable'
        , 48
        , 39
        , 'http://www.supp-102055.com/cat/hw/p3110.html');
        
        insert into oehr_product_information values 
        (3108
        , 'KB E/EN'
        , 'Ergonomic Keyboard with two separate key areas,
        detachable numeric pad. Key layout: English (US).'
        , 16,2
        , to_yminterval('+02-00')
        , 102055
        , 'orderable'
        , 78
        , 63
        , 'http://www.supp-102055.com/cat/hw/p3108.html');
        
        insert into oehr_product_information values 
        (2058
        , 'Mouse +WP'
        , 'Combination of a mouse and a wrist pad for more
        comfortable typing and mouse operation.'
        , 16,1
        , to_yminterval('+01-00')
        , 102055
        , 'orderable'
        , 23
        , 19
        , 'http://www.supp-102055.com/cat/hw/p2058.html');
        
        insert into oehr_product_information values 
        (2761
        , 'Mouse +WP/CL'
        , 'Set consisting of a mouse and wrist pad,
        with corporate logo'
        , 16,1
        , to_yminterval('+01-06')
        , 102099
        , 'planned'
        , 27
        , 23
        , 'http://www.supp-102099.com/cat/hw/p2761.html');
        
        insert into oehr_product_information values 
        (3117
        , 'Mouse C/E'
        , 'Ergonomic, cordless mouse. With track-ball
        for maximum comfort and ease of use.'
        , 16,1
        , to_yminterval('+01-00')
        , 102099
        , 'orderable'
        , 41
        , 35
        , 'http://www.supp-102099.com/cat/hw/p3117.html');
        
        insert into oehr_product_information values 
        (2056
        , 'Mouse Pad /CL'
        , 'Standard mouse pad, with corporate logo'
        , 16,1
        , to_yminterval('+01-00')
        , 102099
        , 'planned'
        , 8
        , 6
        , 'http://www.supp-102099.com/cat/hw/p2056.html');
        
        insert into oehr_product_information values 
        (2211
        , 'Wrist Pad'
        , 'A foam strip to support your wrists when using a keyboard'
        , 16,1
        , to_yminterval('+01-00')
        , 102072
        , 'orderable'
        , 4
        , 3
        , 'http://www.supp-102072.com/cat/hw/p2211.html');
        
        insert into oehr_product_information values 
        (2944
        , 'Wrist Pad /CL'
        , 'Wrist Pad with corporate logo'
        , 16,1
        , to_yminterval('+01-00')
        , 102063
        , 'under development'
        , 3
        , 2
        , 'http://www.supp-102063.com/cat/hw/p2944.html');
        
        insert into oehr_product_information values 
        (1742
        , 'CD-ROM 500/16x'
        , 'CD drive, read only, speed 16x, maximum capacity 500 MB.'
        , 17,1
        , to_yminterval('+00-06')
        , 102052
        , 'orderable'
        , 101
        , 81
        , 'http://www.supp-102052.com/cat/hw/p1742.html');
        
        insert into oehr_product_information values 
        (2402
        , 'CD-ROM 600/E/24x'
        , '600 MB external 24x speed CD-ROM drive (read only).'
        , 17,2
        , to_yminterval('+00-09')
        , 102052
        , 'orderable'
        , 127
        , 113
        , 'http://www.supp-102052.com/cat/hw/p2402.html');
        
        insert into oehr_product_information values 
        (2403
        , 'CD-ROM 600/I/24x'
        , '600 MB internal read only CD-ROM drive,
        reading speed 24x'
        , 17,2
        , to_yminterval('+01-00')
        , 102052
        , 'orderable'
        , 117
        , 103
        , 'http://www.supp-102052.com/cat/hw/p2403.html');
        
        insert into oehr_product_information values 
        (1761
        , 'CD-ROM 600/I/32x'
        , '600 MB Internal CD-ROM Drive, speed 32x (read only).'
        , 17,2
        , to_yminterval('+01-00')
        , 102052
        , 'under development'
        , 134
        , 119
        , 'http://www.supp-102052.com/cat/hw/p1761.html');
        
        insert into oehr_product_information values 
        (2381
        , 'CD-ROM 8x'
        , 'CD Writer, read only, speed 8x'
        , 17,1
        , to_yminterval('+00-03')
        , 102052
        , 'obsolete'
        , 99
        , 82
        , 'http://www.supp-102052.com/cat/hw/p2381.html');
        
        insert into oehr_product_information values 
        (2424
        , 'CDW 12/24'
        , 'CD Writer, speed 12x write, 24x read. Warning: will become obsolete very
        soon; this speed is not high enough anymore, and better alternatives are
        available for a reasonable price.'
        , 17,2
        , to_yminterval('+00-06')
        , 102075
        , 'orderable'
        , 221
        , 198
        , 'http://www.supp-102075.com/cat/hw/p2424.html');
        
        insert into oehr_product_information values 
        (1781
        , 'CDW 20/48/E'
        , 'CD Writer, read 48x, write 20x'
        , 17,2
        , to_yminterval('+00-09')
        , 102060
        , 'orderable'
        , 233
        , 206
        , 'http://www.supp-102060.com/cat/hw/p1781.html');
        
        insert into oehr_product_information values 
        (2264
        , 'CDW 20/48/I'
        , 'CD-ROM drive: read 20x, write 48x (internal)'
        , 17,2
        , to_yminterval('+00-09')
        , 102060
        , 'orderable'
        , 223
        , 181
        , 'http://www.supp-102060.com/cat/hw/p2264.html');
        
        insert into oehr_product_information values 
        (2260
        , 'DFD 1.44/3.5'
        , 'Dual Floppy Drive - 1.44 MB - 3.5'
        , 17,2
        , to_yminterval('+00-06')
        , 102062
        , 'orderable'
        , 67
        , 54
        , 'http://www.supp-102062.com/cat/hw/p2260.html');
        
        insert into oehr_product_information values 
        (2266
        , 'DVD 12x'
        , 'DVD-ROM drive: speed 12x'
        , 17,3
        , to_yminterval('+01-00')
        , 102099
        , 'orderable'
        , 333
        , 270
        , 'http://www.supp-102099.com/cat/hw/p2266.html');
        
        insert into oehr_product_information values 
        (3077
        , 'DVD 8x'
        , 'DVD - ROM drive, 8x speed. Will probably become
        obsolete pretty soon...'
        , 17,3
        , to_yminterval('+01-00')
        , 102099
        , 'orderable'
        , 274
        , 237
        , 'http://www.supp-102099.com/cat/hw/p3077.html');
        
        insert into oehr_product_information values 
        (2259
        , 'FD 1.44/3.5'
        , 'Floppy Drive - 1.44 MB High Density
        capacity - 3.5 inch chassis'
        , 17,1
        , to_yminterval('+00-09')
        , 102086
        , 'orderable'
        , 39
        , 32
        , 'http://www.supp-102086.com/cat/hw/p2259.html');
        
        insert into oehr_product_information values 
        (2261
        , 'FD 1.44/3.5/E'
        , 'Floppy disk drive - 1.44 MB (high density)
        capacity - 3.5 inch (external)'
        , 17,2
        , to_yminterval('+00-09')
        , 102086
        , 'orderable'
        , 42
        , 37
        , 'http://www.supp-102086.com/cat/hw/p2261.html');
        
        insert into oehr_product_information values 
        (3082
        , 'Modem - 56/90/E'
        , 'Modem - 56kb per second, v.90 PCI Global compliant.
        External; for power supply 110V.'
        , 17,1
        , to_yminterval('+01-00')
        , 102068
        , 'orderable'
        , 81
        , 72
        , 'http://www.supp-102068.com/cat/hw/p3082.html');
        
        insert into oehr_product_information values 
        (2270
        , 'Modem - 56/90/I'
        , 'Modem - 56kb per second, v.90 PCI Global compliant.
        Internal, for standard chassis (3.5 inch).'
        , 17,1
        , to_yminterval('+01-00')
        , 102068
        , 'orderable'
        , 66
        , 56
        , 'http://www.supp-102068.com/cat/hw/p2270.html');
        
        insert into oehr_product_information values 
        (2268
        , 'Modem - 56/H/E'
        , 'Standard Hayes compatible modem - 56kb per second, external.
        Power supply: 220V.'
        , 17,1
        , to_yminterval('+01-00')
        , 102068
        , 'obsolete'
        , 77
        , 67
        , 'http://www.supp-102068.com/cat/hw/p2268.html');
        
        insert into oehr_product_information values 
        (3083
        , 'Modem - 56/H/I'
        , 'Standard Hayes modem - 56kb per second, internal, for
         standard 3.5 inch chassis.'
        , 17,1
        , to_yminterval('+01-00')
        , 102068
        , 'orderable'
        , 67
        , 56
        , 'http://www.supp-102068.com/cat/hw/p3083.html');
        
        insert into oehr_product_information values 
        (2374
        , 'Modem - C/100'
        , 'DOCSIS/EURODOCSIS 1.0/1.1-compliant external cable modem'
        , 17,2
        , to_yminterval('+01-06')
        , 102064
        , 'orderable'
        , 65
        , 54
        , 'http://www.supp-102064.com/cat/hw/p2374.html');
        
        insert into oehr_product_information values 
        (1740
        , 'TD 12GB/DAT'
        , 'Tape drive - 12 gigabyte capacity, DAT format.'
        , 17,2
        , to_yminterval('+01-06')
        , 102075
        , 'orderable'
        , 134
        , 111
        , 'http://www.supp-102075.com/cat/hw/p1740.html');
        
        insert into oehr_product_information values 
        (2409
        , 'TD 7GB/8'
        , 'Tape drive, 7GB capacity, 8mm cartridge tape.'
        , 17,2
        , to_yminterval('+01-06')
        , 102054
        , 'orderable'
        , 210
        , 177
        , 'http://www.supp-102054.com/cat/hw/p2409.html');
        
        insert into oehr_product_information values 
        (2262
        , 'ZIP 100'
        , 'ZIP Drive, 100 MB capacity (external) plus cable for
        parallel port connection'
        , 17,2
        , to_yminterval('+01-06')
        , 102054
        , 'orderable'
        , 98
        , 81
        , 'http://www.supp-102054.com/cat/hw/p2262.html');
        
        insert into oehr_product_information values 
        (2522
        , 'Battery - EL'
        , 'Extended life battery, for laptop computers'
        , 19,2
        , to_yminterval('+00-03')
        , 102078
        , 'orderable'
        , 44
        , 39
        , 'http://www.supp-102078.com/cat/hw/p2522.html');
        
        insert into oehr_product_information values 
        (2278
        , 'Battery - NiHM'
        , 'Rechargeable NiHM battery for laptop computers'
        , 19,1
        , to_yminterval('+00-03')
        , 102078
        , 'orderable'
        , 55
        , 48
        , 'http://www.supp-102078.com/cat/hw/p2278.html');
        
        insert into oehr_product_information values 
        (2418
        , 'Battery Backup (DA-130)'
        , 'Single-battery charger with LED indicators'
        , 19,1
        , to_yminterval('+00-03')
        , 102074
        , 'orderable'
        , 61
        , 52
        , 'http://www.supp-102074.com/cat/hw/p2418.html');
        
        insert into oehr_product_information values 
        (2419
        , 'Battery Backup (DA-290)'
        , 'Two-battery charger with LED indicators'
        , 19,1
        , to_yminterval('+00-03')
        , 102074
        , 'orderable'
        , 72
        , 60
        , 'http://www.supp-102074.com/cat/hw/p2419.html');
        
        insert into oehr_product_information values 
        (3097
        , 'Cable Connector - 32R'
        , 'Cable Connector - 32 pin ribbon'
        , 19,1
        , to_yminterval('+00-00')
        , 102055
        , 'orderable'
        , 3
        , 2
        , 'http://www.supp-102055.com/cat/hw/p3097.html');
        
        insert into oehr_product_information values 
        (3099
        , 'Cable Harness'
        , 'Cable harness to organize and bundle computer wiring'
        , 19,1
        , to_yminterval('+00-00')
        , 102055
        , 'orderable'
        , 4
        , 3
        , 'http://www.supp-102055.com/cat/hw/p3099.html');
        
        insert into oehr_product_information values 
        (2380
        , 'Cable PR/15/P'
        , '15 foot parallel printer cable'
        , 19,2
        , to_yminterval('+00-01')
        , 102055
        , 'orderable'
        , 6
        , 5
        , 'http://www.supp-102055.com/cat/hw/p2380.html');
        
        insert into oehr_product_information values 
        (2408
        , 'Cable PR/P/6'
        , 'Standard Centronics 6ft printer cable, parallel port'
        , 19,1
        , to_yminterval('+00-01')
        , 102055
        , 'orderable'
        , 4
        , 3
        , 'http://www.supp-102055.com/cat/hw/p2408.html');
        
        insert into oehr_product_information values 
        (2457
        , 'Cable PR/S/6'
        , 'Standard RS232 serial printer cable, 6 feet'
        , 19,1
        , to_yminterval('+00-01')
        , 102055
        , 'orderable'
        , 5
        , 4
        , 'http://www.supp-102055.com/cat/hw/p2457.html');
        
        insert into oehr_product_information values 
        (2373
        , 'Cable RS232 10/AF'
        , '10 ft RS232 cable with F/F and 9F/25F adapters'
        , 19,2
        , to_yminterval('+01-00')
        , 102055
        , 'orderable'
        , 6
        , 4
        , 'http://www.supp-102055.com/cat/hw/p2373.html');
        
        insert into oehr_product_information values 
        (1734
        , 'Cable RS232 10/AM'
        , '10 ft RS232 cable with M/M and 9M/25M adapters'
        , 19,2
        , to_yminterval('+01-00')
        , 102055
        , 'orderable'
        , 6
        , 5
        , 'http://www.supp-102055.com/cat/hw/p1734.html');
        
        insert into oehr_product_information values 
        (1737
        , 'Cable SCSI 10/FW/ADS'
        , '10ft SCSI2 F/W Adapt to DSxx0 Cable'
        , 19,2
        , to_yminterval('+00-02')
        , 102095
        , 'orderable'
        , 8
        , 6
        , 'http://www.supp-102095.com/cat/hw/p1737.html');
        
        insert into oehr_product_information values 
        (1745
        , 'Cable SCSI 20/WD->D'
        , '20ft SCSI2 Wide Disk Store to Disk Store Cable'
        , 19,2
        , to_yminterval('+00-02')
        , 102095
        , 'orderable'
        , 9
        , 7
        , 'http://www.supp-102095.com/cat/hw/p1745.html');
        
        insert into oehr_product_information values 
        (2982
        , 'Drive Mount - A'
        , 'Drive Mount assembly kit'
        , 19,2
        , to_yminterval('+00-01')
        , 102057
        , 'orderable'
        , 44
        , 35
        , 'http://www.supp-102057.com/cat/hw/p2982.html');
        
        insert into oehr_product_information values 
        (3277
        , 'Drive Mount - A/T'
        , 'Drive Mount assembly kit for tower PC'
        , 19,2
        , to_yminterval('+01-00')
        , 102057
        , 'orderable'
        , 36
        , 29
        , 'http://www.supp-102057.com/cat/hw/p3277.html');
        
        insert into oehr_product_information values 
        (2976
        , 'Drive Mount - D'
        , 'Drive Mount for desktop PC'
        , 19,2
        , to_yminterval('+01-00')
        , 102057
        , 'orderable'
        , 52
        , 44
        , 'http://www.supp-102057.com/cat/hw/p2976.html');
        
        insert into oehr_product_information values 
        (3204
        , 'Envoy DS'
        , 'Envoy Docking Station'
        , 19,3
        , to_yminterval('+02-00')
        , 102060
        , 'orderable'
        , 126
        , 107
        , 'http://www.supp-102060.com/cat/hw/p3204.html');
        
        insert into oehr_product_information values 
        (2638
        , 'Envoy DS/E'
        , 'Enhanced Envoy Docking Station'
        , 19,3
        , to_yminterval('+02-00')
        , 102060
        , 'orderable'
        , 137
        , 111
        , 'http://www.supp-102060.com/cat/hw/p2638.html');
        
        insert into oehr_product_information values 
        (3020
        , 'Envoy IC'
        , 'Envoy Internet Computer, Plug&Play'
        , 19,4
        , to_yminterval('+01-00')
        , 102060
        , 'orderable'
        , 449
        , 366
        , 'http://www.supp-102060.com/cat/hw/p3020.html');
        
        insert into oehr_product_information values 
        (1948
        , 'Envoy IC/58'
        , 'Internet computer with built-in 58K modem'
        , 19,4
        , to_yminterval('+01-06')
        , 102060
        , 'orderable'
        , 498
        , 428
        , 'http://www.supp-102060.com/cat/hw/p1948.html');
        
        insert into oehr_product_information values 
        (3003
        , 'Laptop 128/12/56/v90/110'
        , 'Envoy Laptop, 128MB memory, 12GB hard disk, v90 modem,
        110V power supply.'
        , 19,4
        , to_yminterval('+01-06')
        , 102060
        , 'orderable'
        , 3219
        , 2606
        , 'http://www.supp-102060.com/cat/hw/p3003.html');
        
        insert into oehr_product_information values 
        (2999
        , 'Laptop 16/8/110'
        , 'Envoy Laptop, 16MB memory, 8GB hard disk,
        110V power supply (US only).'
        , 19,3
        , to_yminterval('+01-06')
        , 102060
        , 'obsolete'
        , 999
        , 800
        , 'http://www.supp-102060.com/cat/hw/p2999.html');
        
        insert into oehr_product_information values 
        (3000
        , 'Laptop 32/10/56'
        , 'Envoy Laptop, 32MB memory, 10GB hard disk, 56K Modem,
        universal power supply (switchable).'
        , 19,4
        , to_yminterval('+01-06')
        , 102060
        , 'orderable'
        , 1749
        , 1542
        , 'http://www.supp-102060.com/cat/hw/p3000.html');
      end;~';
   insert into wwv_sample_dmls (wwv_sample_dataset_id, language_cd, dml_name, install_seq, dml) 
   values (  3, 'en', 'Insert Into product information (Part 2)', 31, l_clob);

   l_clob :=q'~begin        
        insert into oehr_product_information values 
        (3001
        , 'Laptop 48/10/56/110'
        , 'Envoy Laptop, 48MB memory, 10GB hard disk, 56K modem,
        110V power supply.'
        , 19,4
        , to_yminterval('+01-06')
        , 102060
        , 'obsolete'
        , 2556
        , 2073
        , 'http://www.supp-102060.com/cat/hw/p3001.html');
        
        insert into oehr_product_information values 
        (3004
        , 'Laptop 64/10/56/220'
        , 'Envoy Laptop, 64MB memory, 10GB hard disk, 56K modem,
        220V power supply.'
        , 19,4
        , to_yminterval('+01-06')
        , 102060
        , 'orderable'
        , 2768
        , 2275
        , 'http://www.supp-102060.com/cat/hw/p3004.html');
        
        insert into oehr_product_information values 
        (3391
        , 'PS 110/220'
        , 'Power Supply - switchable, 110V/220V'
        , 19,2
        , to_yminterval('+01-06')
        , 102062
        , 'orderable'
        , 85
        , 75
        , 'http://www.supp-102062.com/cat/hw/p3391.html');
        
        insert into oehr_product_information values 
        (3124
        , 'PS 110V /T'
        , 'Power supply for tower PC, 110V'
        , 19,2
        , to_yminterval('+01-00')
        , 102062
        , 'orderable'
        , 84
        , 70
        , 'http://www.supp-102062.com/cat/hw/p3124.html');
        
        insert into oehr_product_information values 
        (1738
        , 'PS 110V /US'
        , '110 V Power Supply - US compatible'
        , 19,2
        , to_yminterval('+01-00')
        , 102062
        , 'orderable'
        , 86
        , 70
        , 'http://www.supp-102062.com/cat/hw/p1738.html');

        insert into oehr_product_information values 
        (2377
        , 'PS 110V HS/US'
        , '110 V hot swappable power supply - US compatible'
        , 19,2
        , to_yminterval('+01-00')
        , 102062
        , 'orderable'
        , 97
        , 82
        , 'http://www.supp-102062.com/cat/hw/p2377.html');
        
        insert into oehr_product_information values 
        (2299
        , 'PS 12V /P'
        , 'Power Supply - 12v portable'
        , 19,2
        , to_yminterval('+01-00')
        , 102062
        , 'orderable'
        , 76
        , 64
        , 'http://www.supp-102062.com/cat/hw/p2299.html');
        
        insert into oehr_product_information values 
        (3123
        , 'PS 220V /D'
        , 'Standard power supply, 220V, for desktop computers.'
        , 19,2
        , to_yminterval('+01-00')
        , 102062
        , 'orderable'
        , 81
        , 65
        , 'http://www.supp-102062.com/cat/hw/p3123.html');
        
        insert into oehr_product_information values 
        (1748
        , 'PS 220V /EUR'
        , '220 Volt Power supply type - Europe'
        , 19,2
        , to_yminterval('+01-00')
        , 102053
        , 'orderable'
        , 83
        , 70
        , 'http://www.supp-102053.com/cat/hw/p1748.html');
        
        insert into oehr_product_information values 
        (2387
        , 'PS 220V /FR'
        , '220V Power supply type - France'
        , 19,2
        , to_yminterval('+01-00')
        , 102053
        , 'orderable'
        , 83
        , 66
        , 'http://www.supp-102053.com/cat/hw/p2387.html');
        
        insert into oehr_product_information values 
        (2370
        , 'PS 220V /HS/FR'
        , '220V hot swappable power supply, for France.'
        , 19,2
        , to_yminterval('+00-09')
        , 102053
        , 'orderable'
        , 91
        , 75
        , 'http://www.supp-102053.com/cat/hw/p2370.html');
        
        insert into oehr_product_information values 
        (2311
        , 'PS 220V /L'
        , 'Power supply for laptop computers, 220V'
        , 19,2
        , to_yminterval('+00-09')
        , 102053
        , 'orderable'
        , 95
        , 79
        , 'http://www.supp-102053.com/cat/hw/p2311.html');
        
        insert into oehr_product_information values 
        (1733
        , 'PS 220V /UK'
        , '220V Power supply type - United Kingdom'
        , 19,2
        , to_yminterval('+00-09')
        , 102080
        , 'orderable'
        , 89
        , 76
        , 'http://www.supp-102080.com/cat/hw/p1733.html');
        
        insert into oehr_product_information values 
        (2878
        , 'Router - ASR/2W'
        , 'Special ALS Router - Approved Supplier required item with 2-way match'
        , 19,3
        , to_yminterval('+00-09')
        , 102063
        , 'orderable'
        , 345
        , 305
        , 'http://www.supp-102063.com/cat/hw/p2878.html');
        
        insert into oehr_product_information values 
        (2879
        , 'Router - ASR/3W'
        , 'Special ALS Router - Approved Supplier required item with 3-way match'
        , 19,3
        , to_yminterval('+00-09')
        , 102063
        , 'orderable'
        , 456
        , 384
        , 'http://www.supp-102063.com/cat/hw/p2879.html');
        
        insert into oehr_product_information values 
        (2152
        , 'Router - DTMF4'
        , 'DTMF 4 port router'
        , 19,3
        , to_yminterval('+00-09')
        , 102063
        , 'obsolete'
        , 231
        , 191
        , 'http://www.supp-102063.com/cat/hw/p2152.html');
        
        insert into oehr_product_information values 
        (3301
        , 'Screws <B.28.P>'
        , 'Screws: Brass, size 28mm, Phillips head. Plastic box, contents 500.'
        , 19,2
        , to_yminterval('+00-00')
        , 102071
        , 'orderable'
        , 15
        , 12
        , 'http://www.supp-102071.com/cat/hw/p3301.html');
        
        insert into oehr_product_information values 
        (3143
        , 'Screws <B.28.S>'
        , 'Screws: Brass, size 28mm, straight. Plastic box, contents 500.'
        , 19,2
        , to_yminterval('+00-00')
        , 102071
        , 'orderable'
        , 16
        , 13
        , 'http://www.supp-102071.com/cat/hw/p3143.html');
        
        insert into oehr_product_information values 
        (2323
        , 'Screws <B.32.P>'
        , 'Screws: Brass, size 32mm, Phillips head. Plastic box, contents 400.'
        , 19,3
        , to_yminterval('+00-00')
        , 102071
        , 'orderable'
        , 18
        , 14
        , 'http://www.supp-102071.com/cat/hw/p2323.html');
        
        insert into oehr_product_information values 
        (3134
        , 'Screws <B.32.S>'
        , 'Screws: Brass, size 32mm, straight. Plastic box, contents 400.'
        , 19,3
        , to_yminterval('+00-00')
        , 102071
        , 'orderable'
        , 18
        , 15
        , 'http://www.supp-102071.com/cat/hw/p3134.html');
        
        insert into oehr_product_information values 
        (3139
        , 'Screws <S.16.S>'
        , 'Screws: Steel, size 16 mm, straight. Carton box, contents 750.'
        , 19,2
        , to_yminterval('+00-00')
        , 102071
        , 'orderable'
        , 21
        , 17
        , 'http://www.supp-102071.com/cat/hw/p3139.html');
        
        insert into oehr_product_information values 
        (3300
        , 'Screws <S.32.P>'
        , 'Screws: Steel, size 32mm, Phillips head. Plastic box, contents 400.'
        , 19,3
        , to_yminterval('+00-00')
        , 102071
        , 'orderable'
        , 23
        , 19
        , 'http://www.supp-102071.com/cat/hw/p3300.html');
        
        insert into oehr_product_information values 
        (2316
        , 'Screws <S.32.S>'
        , 'Screws: Steel, size 32mm, straight. Plastic box, contents 500.'
        , 19,3
        , to_yminterval('+00-00')
        , 102074
        , 'orderable'
        , 22
        , 19
        , 'http://www.supp-102074.com/cat/hw/p2316.html');
        
        insert into oehr_product_information values 
        (3140
        , 'Screws <Z.16.S>'
        , 'Screws: Zinc, length 16mm, straight. Carton box, contents 750.'
        , 19,2
        , to_yminterval('+00-00')
        , 102074
        , 'orderable'
        , 24
        , 19
        , 'http://www.supp-102074.com/cat/hw/p3140.html');
        
        insert into oehr_product_information values 
        (2319
        , 'Screws <Z.24.S>'
        , 'Screws: Zinc, size 24mm, straight. Carton box, contents 500.'
        , 19,2
        , to_yminterval('+00-00')
        , 102074
        , 'orderable'
        , 25
        , 21
        , 'http://www.supp-102074.com/cat/hw/p2319.html');
        
        insert into oehr_product_information values 
        (2322
        , 'Screws <Z.28.P>'
        , 'Screws: Zinc, size 28 mm, Phillips head. Carton box, contents 850.'
        , 19,2
        , to_yminterval('+00-00')
        , 102076
        , 'orderable'
        , 23
        , 18
        , 'http://www.supp-102076.com/cat/hw/p2322.html');
        
        insert into oehr_product_information values 
        (3178
        , 'Spreadsheet - SSP/V 2.0'
        , 'SmartSpread Spreadsheet, Professional Edition Version 2.0, for Vision
        Release 11.1 and 11.2. Shrink wrap includes CD-ROM containing advanced
        software and online documentation, plus printed manual, tutorial, and
        license registration.'
        , 21,2
        , to_yminterval('+00-01')
        , 103080
        , 'orderable'
        , 45
        , 37
        , 'http://www.supp-103080.com/cat/sw/p3178.html');
        
        insert into oehr_product_information values 
        (3179
        , 'Spreadsheet - SSS/S 2.1'
        , 'SmartSpread Spreadsheet, Standard Edition Version 2.1, for SPNIX Release
        4.0. Shrink wrap includes CD-ROM containing software and online
        documentation, plus printed manual and license registration.'
        , 21,2
        , to_yminterval('+00-01')
        , 103080
        , 'orderable'
        , 50
        , 44
        , 'http://www.supp-103080.com/cat/sw/p3179.html');
        
        insert into oehr_product_information values 
        (3182
        , 'Word Processing - SWP/V 4.5'
        , 'SmartWord Word Processor, Professional Edition Version 4.5, for Vision
        Release 11.x. Shrink wrap includes CD-ROM, containing advanced software,
        printed manual, and license registration.'
        , 22,2
        , to_yminterval('+00-03')
        , 103093
        , 'orderable'
        , 65
        , 54
        , 'http://www.supp-103093.com/cat/sw/p3182.html');
        
        insert into oehr_product_information values 
        (3183
        , 'Word Processing - SWS/V 4.5'
        , 'SmartWord Word Processor, Standard Edition Version 4.5, for Vision
        Release 11.x. Shrink wrap includes CD-ROM and license registration.'
        , 22,2
        , to_yminterval('+00-01')
        , 103093
        , 'orderable'
        , 50
        , 40
        , 'http://www.supp-103093.com/cat/sw/p3183.html');
        
        insert into oehr_product_information values 
        (3197
        , 'Spreadsheet - SSS/V 2.1'
        , 'SmartSpread Spreadsheet, Standard Edition Version 2.1, for Vision
        Release 11.1 and 11.2. Shrink wrap includes CD-ROM containing software
        and online documentation, plus printed manual, tutorial, and license
        registration.'
        , 21,2
        , to_yminterval('+00-01')
        , 103080
        , 'orderable'
        , 45
        , 36
        , 'http://www.supp-103080.com/cat/sw/p3197.html');
        
        insert into oehr_product_information values 
        (3255
        , 'Spreadsheet - SSS/CD 2.2B'
        , 'SmartSpread Spreadsheet, Standard Edition, Beta Version 2.2, for
        SPNIX Release 4.1. CD-ROM only.'
        , 21,1
        , to_yminterval('+00-01')
        , 103080
        , 'orderable'
        , 35
        , 30
        , 'http://www.supp-103080.com/cat/sw/p3255.html');
        
        insert into oehr_product_information values 
        (3256
        , 'Spreadsheet - SSS/V 2.0'
        , 'SmartSpread Spreadsheet, Standard Edition Version 2.0, for Vision
        Release 11.0. Shrink wrap includes CD-ROM containing software and
        online documentation, plus printed manual, tutorial, and license
        registration.'
        , 21,2
        , to_yminterval('+00-01')
        , 103080
        , 'orderable'
        , 40
        , 34
        , 'http://www.supp-103080.com/cat/sw/p3256.html');
        
        insert into oehr_product_information values 
        (3260
        , 'Word Processing - SWP/S 4.4'
        , 'SmartSpread Spreadsheet, Standard Edition Version 2.2, for SPNIX
        Release 4.x. Shrink wrap includes CD-ROM, containing software, plus
        printed manual and license registration.'
        , 22,2
        , to_yminterval('+00-01')
        , 103093
        , 'orderable'
        , 50
        , 41
        , 'http://www.supp-103093.com/cat/sw/p3260.html');
        
        insert into oehr_product_information values 
        (3262
        , 'Spreadsheet - SSS/S 2.2'
        , 'SmartSpread Spreadsheet, Standard Edition Version 2.2, for SPNIX
        Release 4.1. Shrink wrap includes CD-ROM containing software and
        online documentation, plus printed manual and license registration.'
        , 21,2
        , to_yminterval('+00-01')
        , 103080
        , 'under development'
        , 50
        , 41
        , 'http://www.supp-103080.com/cat/sw/p3262.html');
        
        insert into oehr_product_information values 
        (3361
        , 'Spreadsheet - SSP/S 1.5'
        , 'SmartSpread Spreadsheet, Standard Edition Version 1.5, for SPNIX
        Release 3.3. Shrink wrap includes CD-ROM containing advanced software and
        online documentation, plus printed manual, tutorial, and license registration.'
        , 21,2
        , to_yminterval('+00-01')
        , 103080
        , 'orderable'
        , 40
        , 34
        , 'http://www.supp-103080.com/cat/sw/p3361.html');
        
        insert into oehr_product_information values 
        (1799
        , 'SPNIX3.3 - SL'
        , 'Operating System Software: SPNIX V3.3 - Base Server License. Includes
        10 general licenses for system administration, developers, or users. No
        network user licensing. '
        , 24,1
        , to_yminterval('+01-00')
        , 103092
        , 'orderable'
        , 1000
        , 874
        , 'http://www.supp-103092.com/cat/sw/p1799.html');
        
        insert into oehr_product_information values 
        (1801
        , 'SPNIX3.3 - AL'
        , 'Operating System Software: SPNIX V3.3 - Additional system
        administrator license, including network access.'
        , 24,1
        , to_yminterval('+01-00')
        , 103092
        , 'orderable'
        , 100
        , 88
        , 'http://www.supp-103092.com/cat/sw/p1801.html');
        
        insert into oehr_product_information values 
        (1803
        , 'SPNIX3.3 - DL'
        , 'Operating System Software: SPNIX V3.3 - Additional developer license.'
        , 24,1
        , to_yminterval('+01-00')
        , 103092
        , 'orderable'
        , 60
        , 51
        , 'http://www.supp-103092.com/cat/sw/p1803.html');
        
        insert into oehr_product_information values 
        (1804
        , 'SPNIX3.3 - UL/N'
        , 'Operating System Software: SPNIX V3.3 - Additional user license with
        network access.'
        , 24,1
        , to_yminterval('+01-00')
        , 103092
        , 'orderable'
        , 65
        , 56
        , 'http://www.supp-103092.com/cat/sw/p1804.html');
        
        insert into oehr_product_information values 
        (1805
        , 'SPNIX3.3 - UL/A'
        , 'Operating System Software: SPNIX V3.3 - Additional user license class A.'
        , 24,1
        , to_yminterval('+01-00')
        , 103092
        , 'orderable'
        , 50
        , 42
        , 'http://www.supp-103092.com/cat/sw/p1805.html');
        
        insert into oehr_product_information values 
        (1806
        , 'SPNIX3.3 - UL/C'
        , 'Operating System Software: SPNIX V3.3 - Additional user license class C.'
        , 24,1
        , to_yminterval('+01-00')
        , 103092
        , 'orderable'
        , 50
        , 42
        , 'http://www.supp-103092.com/cat/sw/p1806.html');
        
        insert into oehr_product_information values 
        (1808
        , 'SPNIX3.3 - UL/D'
        , 'Operating System Software: SPNIX V3.3 - Additional user license class D.'
        , 24,1
        , to_yminterval('+01-00')
        , 103092
        , 'orderable'
        , 55
        , 46
        , 'http://www.supp-103092.com/cat/sw/p1808.html');
        
        insert into oehr_product_information values 
        (1820
        , 'SPNIX3.3 - NL'
        , 'Operating System Software: SPNIX V3.3 - Additional network access license.'
        , 24,1
        , to_yminterval('+01-00')
        , 103092
        , 'orderable'
        , 55
        , 45
        , 'http://www.supp-103092.com/cat/sw/p1820.html');
        
        insert into oehr_product_information values 
        (1822
        , 'SPNIX4.0 - SL'
        , 'Operating System Software: SPNIX V4.0 - Base Server License. Includes
        10 general licenses for system administration, developers, or users. No
        network user licensing. '
        , 24,1
        , to_yminterval('+01-00')
        , 103092
        , 'orderable'
        , 1500
        , 1303
        , 'http://www.supp-103092.com/cat/sw/p1822.html');
        
        insert into oehr_product_information values 
        (2422
        , 'SPNIX4.0 - SAL'
        , 'Operating System Software: SPNIX V4.0 - Additional system
        administrator license, including network access.'
        , 24,1
        , to_yminterval('+01-00')
        , 103092
        , 'orderable'
        , 150
        , 130
        , 'http://www.supp-103092.com/cat/sw/p2422.html');
        
        insert into oehr_product_information values 
        (2452
        , 'SPNIX4.0 - DL'
        , 'Operating System Software: SPNIX V4.0 - Additional developer license.'
        , 24,1
        , to_yminterval('+01-00')
        , 103092
        , 'orderable'
        , 100
        , 88
        , 'http://www.supp-103092.com/cat/sw/p2452.html');
        
        insert into oehr_product_information values 
        (2462
        , 'SPNIX4.0 - UL/N'
        , 'Operating System Software: SPNIX V4.0 - Additional user license with
        network access.'
        , 24,1
        , to_yminterval('+01-00')
        , 103092
        , 'orderable'
        , 80
        , 71
        , 'http://www.supp-103092.com/cat/sw/p2462.html');
        
        insert into oehr_product_information values 
        (2464
        , 'SPNIX4.0 - UL/A'
        , 'Operating System Software: SPNIX V4.0 - Additional user license class A.'
        , 24,1
        , to_yminterval('+01-00')
        , 103092
        , 'orderable'
        , 70
        , 62
        , 'http://www.supp-103092.com/cat/sw/p2464.html');
        
        insert into oehr_product_information values 
        (2467
        , 'SPNIX4.0 - UL/D'
        , 'Operating System Software: SPNIX V4.0 - Additional user license class D.'
        , 24,1
        , to_yminterval('+01-00')
        , 103092
        , 'orderable'
        , 80
        , 64
        , 'http://www.supp-103092.com/cat/sw/p2467.html');
        
        insert into oehr_product_information values 
        (2468
        , 'SPNIX4.0 - UL/C'
        , 'Operating System Software: SPNIX V4.0 - Additional user license class C.'
        , 24,1
        , to_yminterval('+01-00')
        , 103092
        , 'orderable'
        , 75
        , 67
        , 'http://www.supp-103092.com/cat/sw/p2468.html');
        
        insert into oehr_product_information values 
        (2470
        , 'SPNIX4.0 - NL'
        , 'Operating System Software: SPNIX V4.0 - Additional network access license.'
        , 24,1
        , to_yminterval('+01-00')
        , 103092
        , 'orderable'
        , 80
        , 70
        , 'http://www.supp-103092.com/cat/sw/p2470.html');
        
        insert into oehr_product_information values 
        (2471
        , 'SPNIX3.3 SU'
        , 'Operating System Software: SPNIX V3.3 - Base Server License Upgrade
        to V4.0.'
        , 24,1
        , to_yminterval('+01-00')
        , 103092
        , 'orderable'
        , 500
        , 439
        , 'http://www.supp-103092.com/cat/sw/p2471.html');
        
        insert into oehr_product_information values 
        (2492
        , 'SPNIX3.3 AU'
        , 'Operating System Software: SPNIX V3.3 - V4.0 upgrade; class A user.'
        , 24,1
        , to_yminterval('+01-00')
        , 103092
        , 'orderable'
        , 45
        , 38
        , 'http://www.supp-103092.com/cat/sw/p2492.html');
        
        insert into oehr_product_information values 
        (2493
        , 'SPNIX3.3 C/DU'
        , 'Operating System Software: SPNIX V3.3 - V4.0 upgrade; class C or D user.'
        , 24,1
        , to_yminterval('+01-00')
        , 103092
        , 'orderable'
        , 25
        , 22
        , 'http://www.supp-103092.com/cat/sw/p2493.html');
        
        insert into oehr_product_information values 
        (2494
        , 'SPNIX3.3 NU'
        , 'Operating System Software: SPNIX V3.3 - V4.0 upgrade;network access license.'
        , 24,1
        , to_yminterval('+01-00')
        , 103092
        , 'orderable'
        , 25
        , 20
        , 'http://www.supp-103092.com/cat/sw/p2494.html');
        
        insert into oehr_product_information values 
        (2995
        , 'SPNIX3.3 SAU'
        , 'Operating System Software: SPNIX V3.3 - V4.0 upgrade; system administrator license.'
        , 24,1
        , to_yminterval('+01-00')
        , 103092
        , 'orderable'
        , 70
        , 62
        , 'http://www.supp-103092.com/cat/sw/p2995.html');
        
        insert into oehr_product_information values 
        (3290
        , 'SPNIX3.3 DU'
        , 'Operating System Software: SPNIX V3.3 - V4.0 upgrade;developer license.'
        , 24,1
        , to_yminterval('+01-00')
        , 103092
        , 'orderable'
        , 65
        , 55
        , 'http://www.supp-103092.com/cat/sw/p3290.html');
        
        insert into oehr_product_information values 
        (1778
        , 'C for SPNIX3.3 - 1 Seat'
        , 'C programming software for SPNIX V3.3 - single user'
        , 25,1
        , to_yminterval('+00-06')
        , 103092
        , 'orderable'
        , 62
        , 52
        , 'http://www.supp-103092.com/cat/sw/p1778.html');
        
        insert into oehr_product_information values 
        (1779
        , 'C for SPNIX3.3 - Doc'
        , 'C programming language documentation
        , SPNIX V3.3'
        , 25,2
        , to_yminterval('+10-00')
        , 103092
        , 'orderable'
        , 128
        , 112
        , 'http://www.supp-103092.com/cat/sw/p1779.html');
        
        insert into oehr_product_information values 
        (1780
        , 'C for SPNIX3.3 - Sys'
        , 'C programming software for SPNIX V3.3 - system compiler,
        libraries, linker'
        , 25,1
        , to_yminterval('+00-06')
        , 103092
        , 'orderable'
        , 450
        , 385
        , 'http://www.supp-103092.com/cat/sw/p1780.html');
        
        insert into oehr_product_information values 
        (2371
        , 'C for SPNIX4.0 - Doc'
        , 'C programming language documentation, SPNIX V4.0'
        , 25,2
        , to_yminterval('+10-00')
        , 103092
        , 'orderable'
        , 146
        , 119
        , 'http://www.supp-103092.com/cat/sw/p2371.html');
        
        insert into oehr_product_information values 
        (2423
        , 'C for SPNIX4.0 - 1 Seat'
        , 'C programming software for SPNIX V4.0 - single user'
        , 25,1
        , to_yminterval('+00-06')
        , 103092
        , 'orderable'
        , 84
        , 73
        , 'http://www.supp-103092.com/cat/sw/p2423.html');
        
        insert into oehr_product_information values 
        (3501
        , 'C for SPNIX4.0 - Sys'
        , 'C programming software for SPNIX V4.0 - system compiler,
        libraries, linker'
        , 25,1
        , to_yminterval('+00-06')
        , 103092
        , 'orderable'
        , 555
        , 448
        , 'http://www.supp-103092.com/cat/sw/p3501.html');
        
        insert into oehr_product_information values 
        (3502
        , 'C for SPNIX3.3 -Sys/U'
        , 'C programming software for SPNIX V3.3 - 4.0 Upgrade;system compiler,libraries, linker'
        , 25,1
        , to_yminterval('+00-06')
        , 103092
        , 'orderable'
        , 105
        , 88
        , 'http://www.supp-103092.com/cat/sw/p3502.html');
        
        insert into oehr_product_information values 
        (3503
        , 'C for SPNIX3.3 - Seat/U'
        , 'C programming software for SPNIX V3.3 - 4.0 Upgrade - single user'
        , 25,1
        , to_yminterval('+00-06')
        , 103092
        , 'orderable'
        , 22
        , 18
        , 'http://www.supp-103092.com/cat/sw/p3503.html');
        
        insert into oehr_product_information values 
        (1774
        , 'Base ISO CP - BL'
        , 'Base ISO Communication Package - Base License'
        , 29,1
        , to_yminterval('+00-00')
        , 103088
        , 'orderable'
        , 110
        , 93
        , 'http://www.supp-103088.com/cat/sw/p1774.html');
        
        insert into oehr_product_information values 
        (1775
        , 'Client ISO CP - S'
        , 'ISO Communication Package add-on license for additional SPNIX V3.3 client.'
        , 29,1
        , to_yminterval('+00-00')
        , 103087
        , 'orderable'
        , 27
        , 22
        , 'http://www.supp-103087.com/cat/sw/p1775.html');
        
        insert into oehr_product_information values 
        (1794
        , 'OSI 8-16/IL'
        , 'OSI Layer 8 to 16 - Incremental License'
        , 29,1
        , to_yminterval('+00-00')
        , 103096
        , 'orderable'
        , 128
        , 112
        , 'http://www.supp-103096.com/cat/sw/p1794.html');
        
        insert into oehr_product_information values 
        (1825
        , 'X25 - 1 Line License'
        , 'X25 network access control system, single user'
        , 29,1
        , to_yminterval('+00-06')
        , 103093
        , 'orderable'
        , 25
        , 21
        , 'http://www.supp-103093.com/cat/sw/p1825.html');
        
        insert into oehr_product_information values 
        (2004
        , 'IC Browser - S'
        , 'IC Web Browser for SPNIX. Browser with network mail capability.'
        , 29,1
        , to_yminterval('+00-01')
        , 103086
        , 'orderable'
        , 90
        , 80
        , 'http://www.supp-103086.com/cat/sw/p2004.html');
        
        insert into oehr_product_information values 
        (2005
        , 'IC Browser Doc - S'
        , 'Documentation set for IC Web Browser for SPNIX. Includes Installation
        Manual, Mail Server Administration Guide, and User Quick Reference.'
        , 29,2
        , to_yminterval('+00-00')
        , 103086
        , 'orderable'
        , 115
        , 100
        , 'http://www.supp-103086.com/cat/sw/p2005.html');
        
        insert into oehr_product_information values 
        (2416
        , 'Client ISO CP - S'
        , 'ISO Communication Package add-on license for additional SPNIX V4.0 client.'
        , 29,1
        , to_yminterval('+00-00')
        , 103088
        , 'orderable'
        , 41
        , 36
        , 'http://www.supp-103088.com/cat/sw/p2416.html');
        
        insert into oehr_product_information values 
        (2417
        , 'Client ISO CP - V'
        , 'ISO Communication Package add-on license for additional Vision client.'
        , 29,1
        , to_yminterval('+00-00')
        , 103088
        , 'orderable'
        , 33
        , 27
        , 'http://www.supp-103088.com/cat/sw/p2417.html');
        
        insert into oehr_product_information values 
        (2449
        , 'OSI 1-4/IL'
        , 'OSI Layer 1 to 4 - Incremental License'
        , 29,1
        , to_yminterval('+00-00')
        , 103088
        , 'orderable'
        , 83
        , 72
        , 'http://www.supp-103088.com/cat/sw/p2449.html');
        
        insert into oehr_product_information values 
        (3101
        , 'IC Browser - V'
        , 'IC Web Browser for Vision with manual. Browser with network mail capability.'
        , 29,2
        , to_yminterval('+00-01')
        , 103086
        , 'orderable'
        , 75
        , 67
        , 'http://www.supp-103086.com/cat/sw/p3101.html');
        
        insert into oehr_product_information values 
        (3170
        , 'Smart Suite - V/SP'
        , 'Office Suite (SmartWrite, SmartArt, SmartSpread, SmartBrowse) for Vision.
        Spanish language software and user manuals.'
        , 29,2
        , to_yminterval('+00-06')
        , 103089
        , 'orderable'
        , 161
        , 132
        , 'http://www.supp-103089.com/cat/sw/p3170.html');
        
        insert into oehr_product_information values 
        (3171
        , 'Smart Suite - S3.3/EN'
        , 'Office Suite (SmartWrite, SmartArt, SmartSpread, SmartBrowse) for SPNIX
        Version 3.3. English language software and user manuals.'
        , 29,2
        , to_yminterval('+00-06')
        , 103089
        , 'orderable'
        , 148
        , 120
        , 'http://www.supp-103089.com/cat/sw/p3171.html');
        
        insert into oehr_product_information values 
        (3172
        , 'Graphics - DIK+'
        , 'Software Kit Graphics: Draw-It Kwik-Plus. Includes extensive clip art
        files and advanced drawing tools for 3-D object manipulation, variable
        shading, and extended character fonts.'
        , 29,1
        , to_yminterval('+00-01')
        , 103094
        , 'orderable'
        , 42
        , 34
        , 'http://www.supp-103094.com/cat/sw/p3172.html');
      end;~';
   insert into wwv_sample_dmls (wwv_sample_dataset_id, language_cd, dml_name, install_seq, dml) 
   values (  3, 'en', 'Insert Into product information (Part 3)', 32, l_clob);

   l_clob :=q'~begin
        insert into oehr_product_information values 
        (3173
        , 'Graphics - SA'
        , 'Software Kit Graphics: SmartArt. Professional graphics package for
        SPNIX with multiple line styles, textures, built-in shapes and common symbols.'
        , 29,1
        , to_yminterval('+00-01')
        , 103094
        , 'orderable'
        , 86
        , 72
        , 'http://www.supp-103094.com/cat/sw/p3173.html');
        
        insert into oehr_product_information values 
        (3175
        , 'Project Management - S4.0'
        , 'Project Management Software, for SPNIX V4.0. Software includes command
        line and graphical interface with text, graphic, spreadsheet, and
        customizable report formats.'
        , 29,1
        , to_yminterval('+00-01')
        , 103089
        , 'orderable'
        , 37
        , 32
        , 'http://www.supp-103089.com/cat/sw/p3175.html');
        
        insert into oehr_product_information values 
        (3176
        , 'Smart Suite - V/EN'
        , 'Office Suite (SmartWrite, SmartArt, SmartSpread, SmartBrowse) for
        Vision. English language software and user manuals.'
        , 29,2
        , to_yminterval('+00-06')
        , 103089
        , 'orderable'
        , 120
        , 103
        , 'http://www.supp-103089.com/cat/sw/p3176.html');
        
        insert into oehr_product_information values 
        (3177
        , 'Smart Suite - V/FR'
        , 'Office Suite (SmartWrite, SmartArt, SmartSpread, SmartBrowse) for
        Vision. French language software and user manuals.'
        , 29,2
        , to_yminterval('+00-06')
        , 103089
        , 'orderable'
        , 120
        , 102
        , 'http://www.supp-103089.com/cat/sw/p3177.html');
        
        insert into oehr_product_information values 
        (3245
        , 'Smart Suite - S4.0/FR'
        , 'Office Suite (SmartWrite, SmartArt, SmartSpread, SmartBrowse) for
        SPNIX V4.0. French language software and user manuals.'
        , 29,2
        , to_yminterval('+00-06')
        , 103089
        , 'orderable'
        , 222
        , 195
        , 'http://www.supp-103089.com/cat/sw/p3245.html');
        
        insert into oehr_product_information values 
        (3246
        , 'Smart Suite - S4.0/SP'
        , 'Office Suite (SmartWrite, SmartArt, SmartSpread, SmartBrowse) for
        SPNIX V4.0. Spanish language software and user manuals.'
        , 29,2
        , to_yminterval('+00-06')
        , 103089
        , 'orderable'
        , 222
        , 193
        , 'http://www.supp-103089.com/cat/sw/p3246.html');
        
        insert into oehr_product_information values 
        (3247
        , 'Smart Suite - V/DE'
        , 'Office Suite (SmartWrite, SmartArt, SmartSpread, SmartBrowse) for
        Vision. German language software and user manuals.'
        , 29,2
        , to_yminterval('+00-06')
        , 103089
        , 'orderable'
        , 120
        , 96
        , 'http://www.supp-103089.com/cat/sw/p3247.html');
        
        insert into oehr_product_information values 
        (3248
        , 'Smart Suite - S4.0/DE'
        , 'Office Suite (SmartWrite, SmartArt, SmartSpread, SmartBrowse) for
        SPNIX V4.0. German language software and user manuals.'
        , 29,2
        , to_yminterval('+00-06')
        , 103089
        , 'orderable'
        , 222
        , 193
        , 'http://www.supp-103089.com/cat/sw/p3248.html');

        insert into oehr_product_information values 
        (3250
        , 'Graphics - DIK'
        , 'Software Kit Graphics: Draw-It Kwik. Simple graphics package for
        Vision systems, with options to save in GIF, JPG, and BMP formats.'
        , 29,1
        , to_yminterval('+00-01')
        , 103083
        , 'orderable'
        , 28
        , 24
        , 'http://www.supp-103083.com/cat/sw/p3250.html');
        
        insert into oehr_product_information values 
        (3251
        , 'Project Management - V'
        , 'Project Management Software, for Vision. Software includes command
        line and graphical interface with text, graphic, spreadsheet, and
        customizable report formats.'
        , 29,1
        , to_yminterval('+00-01')
        , 103093
        , 'orderable'
        , 31
        , 26
        , 'http://www.supp-103093.com/cat/sw/p3251.html');
        
        insert into oehr_product_information values 
        (3252
        , 'Project Management - S3.3'
        , 'Project Management Software, for SPNIX V3.3. Software includes command
        line and graphical interface with text, graphic, spreadsheet, and
        customizable report formats.'
        , 29,1
        , to_yminterval('+00-01')
        , 103093
        , 'orderable'
        , 26
        , 23
        , 'http://www.supp-103093.com/cat/sw/p3252.html');
        
        insert into oehr_product_information values 
        (3253
        , 'Smart Suite - S4.0/EN'
        , 'Office Suite (SmartWrite, SmartArt, SmartSpread, SmartBrowse) for
        SPNIX V4.0. English language software and user manuals.'
        , 29,2
        , to_yminterval('+00-06')
        , 103089
        , 'orderable'
        , 222
        , 188
        , 'http://www.supp-103089.com/cat/sw/p3253.html');
        
        insert into oehr_product_information values 
        (3257
        , 'Web Browser - SB/S 2.1'
        , 'Software Kit Web Browser: SmartBrowse V2.1 for SPNIX V3.3. Includes
        context sensitive help files and online documentation.'
        , 29,1
        , to_yminterval('+00-01')
        , 103082
        , 'orderable'
        , 66
        , 58
        , 'http://www.supp-103082.com/cat/sw/p3257.html');
        
        insert into oehr_product_information values 
        (3258
        , 'Web Browser - SB/V 1.0'
        , 'Software Kit Web Browser: SmartBrowse V2.1 for Vision. Includes
        context sensitive help files and online documentation.'
        , 29,1
        , to_yminterval('+00-01')
        , 103082
        , 'orderable'
        , 80
        , 70
        , 'http://www.supp-103082.com/cat/sw/p3258.html');
        
        insert into oehr_product_information values 
        (3362
        , 'Web Browser - SB/S 4.0'
        , 'Software Kit Web Browser: SmartBrowse V4.0 for SPNIX V4.0. Includes
        context sensitive help files and online documentation.'
        , 29,1
        , to_yminterval('+00-01')
        , 103082
        , 'orderable'
        , 99
        , 81
        , 'http://www.supp-103082.com/cat/sw/p3362.html');
        
        insert into oehr_product_information values 
        (2231
        , 'Desk - S/V'
        , 'Standard-sized desk; capitalizable, taxable item. Final finish is from
        veneer in stock at time of order, including oak, ash, cherry, and mahogany.'
        , 31,5
        , to_yminterval('+15-00')
        , 103082
        , 'orderable'
        , 2510
        , 2114
        , 'http://www.supp-103082.com/cat/off/p2231.html');
        
        insert into oehr_product_information values 
        (2335
        , 'Mobile phone'
        , 'Dual band mobile phone with low battery consumption. Lightweight,
        foldable, with socket for single earphone and spare battery compartment.'
        , 31,1
        , to_yminterval('+01-06')
        , 103088
        , 'orderable'
        , 100
        , 83
        , 'http://www.supp-103088.com/cat/off/p2335.html');
        
        insert into oehr_product_information values 
        (2350
        , 'Desk - W/48'
        , 'Desk - 48 inch white laminate without return; capitalizable, taxable item.'
        , 31,5
        , to_yminterval('+20-00')
        , 103082
        , 'orderable'
        , 2500
        , 2129
        , 'http://www.supp-103082.com/cat/off/p2350.html');
        
        insert into oehr_product_information values 
        (2351
        , 'Desk - W/48/R'
        , 'Desk - 60 inch white laminate with 48 inch return; capitalizable,
        taxable item.'
        , 31,5
        , to_yminterval('+20-0')
        , 103082
        , 'orderable'
        , 2900
        , 2386
        , 'http://www.supp-103082.com/cat/off/p2351.html');
        
        insert into oehr_product_information values 
        (2779
        , 'Desk - OS/O/F'
        , 'Executive-style oversized oak desk with file drawers. Final finish is
        customizable when ordered, light or dark oak stain,
        or natural hand rubbed clear.'
        , 31,5
        , to_yminterval('+25-00')
        , 103082
        , 'orderable'
        , 3980
        , 3347
        , 'http://www.supp-103082.com/cat/off/p2779.html');
        
        insert into oehr_product_information values 
        (3337
        , 'Mobile Web Phone'
        , 'Mobile phone including monthly fee for Web access. Slimline shape
        with leather-look carrying case and belt clip.'
        , 31,2
        , to_yminterval('+01-06')
        , 103088
        , 'orderable'
        , 800
        , 666
        , 'http://www.supp-103088.com/cat/off/p3337.html');
        
        insert into oehr_product_information values 
        (2091
        , 'Paper Tablet LW 8 1/2 x 11'
        , 'Paper tablet, lined, white, size 8 1/2 x 11 inch'
        , 32,1
        , to_yminterval('+00-00')
        , 103095
        , 'orderable'
        , 1
        , 0
        , 'http://www.supp-103095.com/cat/off/p2091.html');
        
        insert into oehr_product_information values 
        (2093
        , 'Pens - 10/FP'
        , 'Permanent ink pen dries quickly and is smear resistant. Provides smooth,
        skip-free writing. Fine point. Single color boxes (black, blue, red) or
        assorted box (6 black, 3 blue, and 1 red).'
        , 32,1
        , to_yminterval('+00-00')
        , 103090
        , 'orderable'
        , 8
        , 7
        , 'http://www.supp-103090.com/cat/off/p2093.html');
        
        insert into oehr_product_information values 
        (2144
        , 'Card Organizer Cover'
        , 'Replacement cover for desk top style business card holder. Smoke
        grey (original color) or clear plastic.'
        , 32,1
        , to_yminterval('+00-01')
        , 103094
        , 'orderable'
        , 18
        , 14
        , 'http://www.supp-103094.com/cat/off/p2144.html');
        
        insert into oehr_product_information values 
        (2336
        , 'Business Cards Box - 250'
        , 'Business cards box, capacity 250. Use form BC110-2, Rev. 3/2000
        (hardcopy or online) when ordering and complete all fields marked
        with an asterisk.'
        , 32,1
        , to_yminterval('+00-00')
        , 103091
        , 'orderable'
        , 55
        , 49
        , 'http://www.supp-103091.com/cat/off/p2336.html');
        
        insert into oehr_product_information values 
        (2337
        , 'Business Cards - 1000/2L'
        , 'Business cards box, capacity 1000, 2-sided with different language on
        each side. Use form BC111-2, Rev. 12/1999 (hardcopy or online) when
        ordering - complete all fields marked with an asterisk and check box for
        second language (English is always on side 1).'
        , 32,1
        , to_yminterval('+00-00')
        , 103091
        , 'orderable'
        , 300
        , 246
        , 'http://www.supp-103091.com/cat/off/p2337.html');
        
        insert into oehr_product_information values 
        (2339
        , 'Paper - Std Printer'
        , '20 lb. 8.5x11 inch white laser printer paper (recycled),
        ten 500-sheet reams'
        , 32,3
        , to_yminterval('+00-00')
        , 103095
        , 'orderable'
        , 25
        , 21
        , 'http://www.supp-103095.com/cat/off/p2339.html');
        
        insert into oehr_product_information values 
        (2536
        , 'Business Cards - 250/2L'
        , 'Business cards box, capacity 250, 2-sided with different language on
        each side. Use form BC111-2, Rev. 12/1999 (hardcopy or online) when
        ordering - complete all fields marked with an asterisk and check box for
        second language (English is always on side 1).'
        , 32,1
        , to_yminterval('+00-00')
        , 103091
        , 'orderable'
        , 80
        , 68
        , 'http://www.supp-103091.com/cat/off/p2536.html');
        
        insert into oehr_product_information values 
        (2537
        , 'Business Cards Box - 1000'
        , 'Business cards box, capacity 1000. Use form BC110-3, Rev. 3/2000
        (hardcopy or online) when ordering and complete all fields marked with
        an asterisk.'
        , 32,1
        , to_yminterval('+00-00')
        , 103091
        , 'orderable'
        , 200
        , 176
        , 'http://www.supp-103091.com/cat/off/p2537.html');
        
        insert into oehr_product_information values 
        (2783
        , 'Clips - Paper'
        , 'World brand paper clips set the standard for quality.10 boxes with 100
        clips each. #1 regular or jumbo, smooth or non-skid.'
        , 32,2
        , to_yminterval('+00-00')
        , 103080
        , 'orderable'
        , 10
        , 8
        , 'http://www.supp-103080.com/cat/off/p2783.html');
        
        insert into oehr_product_information values 
        (2808
        , 'Paper Tablet LY 8 1/2 x 11'
        , 'Paper Tablet, Lined, Yellow, size 8 1/2 x 11 inch'
        , 32,1
        , to_yminterval('+00-00')
        , 103098
        , 'orderable'
        , 1
        , 0
        , 'http://www.supp-103098.com/cat/off/p2808.html');
        
        insert into oehr_product_information values 
        (2810
        , 'Inkvisible Pens'
        , 'Rollerball pen is equipped with a smooth precision tip. See-through
        rubber grip allows for a visible ink supply and comfortable writing.
        4-pack with 1 each, black, blue, red, green.'
        , 32,1
        , to_yminterval('+00-00')
        , 103095
        , 'orderable'
        , 6
        , 4
        , 'http://www.supp-103095.com/cat/off/p2810.html');
        
        insert into oehr_product_information values 
        (2870
        , 'Pencil - Mech'
        , 'Ergonomically designed mechanical pencil for improved writing comfort.
        Refillable erasers and leads. Available in three lead sizes: .5mm (fine);.7mm (medium); and .9mm (thick).'
        , 32,1
        , to_yminterval('+02-00')
        , 103097
        , 'orderable'
        , 5
        , 4
        , 'http://www.supp-103097.com/cat/off/p2870.html');
        
        insert into oehr_product_information values 
        (3051
        , 'Pens - 10/MP'
        , 'Permanent ink pen dries quickly and is smear resistant. Provides smooth,
        skip-free writing. Medium point. Single color boxes (black, blue, red) or
        assorted box (6 black, 3 blue, and 1 red).'
        , 32,1
        , to_yminterval('+00-00')
        , 103097
        , 'orderable'
        , 12
        , 10
        , 'http://www.supp-103097.com/cat/off/p3051.html');
        
        insert into oehr_product_information values 
        (3150
        , 'Card Holder - 25'
        , 'Card Holder; heavy plastic business card holder with embossed corporate
        logo. Holds about 25 of your business cards, depending on card thickness.'
        , 32,1
        , to_yminterval('+00-06')
        , 103089
        , 'orderable'
        , 18
        , 15
        , 'http://www.supp-103089.com/cat/off/p3150.html');
        
        insert into oehr_product_information values 
        (3208
        , 'Pencils - Wood'
        , 'Box of 2 dozen wooden pencils. Specify lead type when ordering: 2H
        (double hard), H (hard), HB (hard black), B (soft black).'
        , 32,1
        , to_yminterval('+00-00')
        , 103097
        , 'orderable'
        , 2
        , 1
        , 'http://www.supp-103097.com/cat/off/p3208.html');
        
        insert into oehr_product_information values 
        (3209
        , 'Sharpener - Pencil'
        , 'Electric Pencil Sharpener Rugged steel cutters for long life.
        PencilSaver helps prevent over-sharpening. Non-skid rubber feet.
        Built-in pencil holder.'
        , 32,2
        , to_yminterval('+02-00')
        , 103096
        , 'orderable'
        , 13
        , 11
        , 'http://www.supp-103096.com/cat/off/p3209.html');
        
        insert into oehr_product_information values 
        (3224
        , 'Card Organizer - 250'
        , 'Portable holder for organizing business cards, capacity 250. Booklet
        style with slip in, transparent pockets for business cards. Optional
        alphabet tabs. Specify cover color when ordering (dark brown, beige,
        burgundy, black, and light grey).'
        , 32,1
        , to_yminterval('+05-00')
        , 103095
        , 'orderable'
        , 32
        , 28
        , 'http://www.supp-103095.com/cat/off/p3224.html');
        
        insert into oehr_product_information values 
        (3225
        , 'Card Organizer - 1000'
        , 'Holder for organizing business cards with alphabet dividers; capacity
        1000. Desk top style with smoke grey cover and black base. Lid is
        removable for storing inside drawer.'
        , 32,1
        , to_yminterval('+00-02')
        , 103095
        , 'orderable'
        , 47
        , 39
        , 'http://www.supp-103095.com/cat/off/p3225.html');
        
        insert into oehr_product_information values 
        (3511
        , 'Paper - HQ Printer'
        , 'Quality paper for inkjet and laser printers tested to resist printer
        jams. Acid free for archival purposes. 22lb. weight with brightness of 92.
        Size: 8 1/2 x 11. Single 500-sheet ream.'
        , 32,2
        , to_yminterval('+00-00')
        , 103080
        , 'orderable'
        , 9
        , 7
        , 'http://www.supp-103080.com/cat/off/p3511.html');
        
        insert into oehr_product_information values 
        (3515
        , 'Lead Replacement'
        , 'Refill leads for mechanical pencils. Each pack contains 25 leads and
        a replacement eraser. Available in three lead sizes: .5mm (fine); .7mm
        (medium); and .9mm (thick).'
        , 32,1
        , to_yminterval('+00-00')
        , 103095
        , 'orderable'
        , 2
        , 1
        , 'http://www.supp-103095.com/cat/off/p3515.html');
        
        insert into oehr_product_information values 
        (2986
        , 'Manual - Vision OS/2x +'
        , 'Manuals for Vision Operating System V 2.x and Vision Office Suite'
        , 33,3
        , to_yminterval('+00-00')
        , 103095
        , 'orderable'
        , 125
        , 111
        , 'http://www.supp-103095.com/cat/off/p2986.html');
        
        insert into oehr_product_information values 
        (3163
        , 'Manual - Vision Net6.3/US'
        , 'Vision Networking V6.3 Reference Manual. US version with advanced
        encryption.'
        , 33,2
        , to_yminterval('+00-00')
        , 103083
        , 'orderable'
        , 35
        , 29
        , 'http://www.supp-103083.com/cat/off/p3163.html');
        
        insert into oehr_product_information values 
        (3165
        , 'Manual - Vision Tools2.0'
        , 'Vision Business Tools Suite V2.0 Reference Manual. Includes installation,
        configuration, and user guide.'
        , 33,2
        , to_yminterval('+00-00')
        , 103083
        , 'orderable'
        , 40
        , 34
        , 'http://www.supp-103083.com/cat/off/p3165.html');
        
        insert into oehr_product_information values 
        (3167
        , 'Manual - Vision OS/2.x'
        , 'Vision Operating System V2.0/2.1/2/3 Reference Manual. Complete
        installation, configuration, management, and tuning information for Vision
        system administration. Note that this manual replaces the individual
        Version 2.0 and 2.1 manuals.'
        , 33,2
        , to_yminterval('+00-00')
        , 103083
        , 'orderable'
        , 55
        , 47
        , 'http://www.supp-103083.com/cat/off/p3167.html');
        
        insert into oehr_product_information values 
        (3216
        , 'Manual - Vision Net6.3'
        , 'Vision Networking V6.3 Reference Manual. Non-US version with basic
        encryption.'
        , 33,2
        , to_yminterval('+00-00')
        , 103083
        , 'orderable'
        , 30
        , 26
        , 'http://www.supp-103083.com/cat/off/p3216.html');
        
        insert into oehr_product_information values 
        (3220
        , 'Manual - Vision OS/1.2'
        , 'Vision Operating System V1.2 Reference Manual. Complete installation,
        configuration, management, and tuning information for Vision system
        administration.'
        , 33,2
        , to_yminterval('+00-00')
        , 103083
        , 'orderable'
        , 45
        , 36
        , 'http://www.supp-103083.com/cat/off/p3220.html');
        
        insert into oehr_product_information values 
        (1729
        , 'Chemicals - RCP'
        , 'Cleaning Chemicals - 3500 roller clean pads'
        , 39,2
        , to_yminterval('+05-00')
        , 103094
        , 'orderable'
        , 80
        , 66
        , 'http://www.supp-103094.com/cat/off/p1729.html');
        
        insert into oehr_product_information values 
        (1910
        , 'FG Stock - H'
        , 'Fiberglass Stock - heavy duty, 1 thick'
        , 39,3
        , to_yminterval('+00-00')
        , 103083
        , 'orderable'
        , 14
        , 11
        , 'http://www.supp-103083.com/cat/off/p1910.html');
        
        insert into oehr_product_information values 
        (1912
        , 'SS Stock - 3mm'
        , 'Stainless steel stock - 3mm. Can be predrilled for standard power
        supplies, motherboard holders, and hard drives. Please use appropriate
        template to identify model number, placement, and size of finished sheet
        when placing order for drilled sheet.'
        , 39,2
        , to_yminterval('+00-00')
        , 103083
        , 'orderable'
        , 15
        , 12
        , 'http://www.supp-103083.com/cat/off/p1912.html');
        
        insert into oehr_product_information values 
        (1940
        , 'ESD Bracelet/Clip'
        , 'Electro static discharge bracelet with alligator clip for easy
        connection to computer chassis or other ground.'
        , 39,1
        , to_yminterval('+01-06')
        , 103095
        , 'orderable'
        , 18
        , 14
        , 'http://www.supp-103095.com/cat/off/p1940.html');
        
        insert into oehr_product_information values 
        (2030
        , 'Latex Gloves'
        , 'Latex Gloves for assemblers, chemical handlers, fitters. Heavy duty,
        safety orange, with textured grip on fingers and thumb. Waterproof and
        shock-proof up to 220 volts/2 amps, 110 volts/5 amps. Acid proof for up
        to 5 minutes.'
        , 39,1
        , to_yminterval('+10-00')
        , 103097
        , 'orderable'
        , 12
        , 10
        , 'http://www.supp-103097.com/cat/off/p2030.html');
        
        insert into oehr_product_information values 
        (2326
        , 'Plastic Stock - Y'
        , 'Plastic Stock - Yellow, standard quality.'
        , 39,1
        , to_yminterval('+00-00')
        , 103093
        , 'orderable'
        , 2
        , 1
        , 'http://www.supp-103093.com/cat/off/p2326.html');
        
        insert into oehr_product_information values 
        (2330
        , 'Plastic Stock - R'
        , 'Plastic Stock - Red, standard quality.'
        , 39,1
        , to_yminterval('+00-00')
        , 103093
        , 'orderable'
        , 2
        , 1
        , 'http://www.supp-103093.com/cat/off/p2330.html');
        
        insert into oehr_product_information values 
        (2334
        , 'Resin'
        , 'General purpose synthetic resin.'
        , 39,2
        , to_yminterval('+00-00')
        , 103087
        , 'orderable'
        , 4
        , 3
        , 'http://www.supp-103087.com/cat/off/p2334.html');
        
        insert into oehr_product_information values 
        (2340
        , 'Chemicals - SW'
        , 'Cleaning Chemicals - 3500 staticide wipes'
        , 39,2
        , to_yminterval('+05-00')
        , 103094
        , 'orderable'
        , 72
        , 59
        , 'http://www.supp-103094.com/cat/off/p2340.html');
        
        insert into oehr_product_information values 
        (2365
        , 'Chemicals - TCS'
        , 'Cleaning Chemical - 2500 transport cleaning sheets'
        , 39,3
        , to_yminterval('+05-00')
        , 103094
        , 'orderable'
        , 78
        , 69
        , 'http://www.supp-103094.com/cat/off/p2365.html');
        
        insert into oehr_product_information values 
        (2594
        , 'FG Stock - L'
        , 'Fiberglass Stock - light weight for internal heat shielding, 1/4 thick'
        , 39,2
        , to_yminterval('+00-00')
        , 103098
        , 'orderable'
        , 9
        , 7
        , 'http://www.supp-103098.com/cat/off/p2594.html');
        
        insert into oehr_product_information values 
        (2596
        , 'SS Stock - 1mm'
        , 'Stainless steel stock - 3mm. Can be predrilled for standard model
        motherboard and battery holders. Please use appropriate template to
        identify model number, placement, and size of finished sheet when placing
        order for drilled sheet.'
        , 39,2
        , to_yminterval('+00-00')
        , 103098
        , 'orderable'
        , 12
        , 10
        , 'http://www.supp-103098.com/cat/off/p2596.html');
        
        insert into oehr_product_information values 
        (2631
        , 'ESD Bracelet/QR'
        , 'Electro Static Discharge Bracelet: 2 piece lead with quick release
        connector. One piece stays permanently attached to computer chassis with
        screw, the other is attached to the bracelet. Additional permanent
        ends available.'
        , 39,1
        , to_yminterval('+01-06')
        , 103085
        , 'orderable'
        , 15
        , 12
        , 'http://www.supp-103085.com/cat/off/p2631.html');
        
        insert into oehr_product_information values 
        (2721
        , 'PC Bag - L/S'
        , 'Black Leather Computer Case - single laptop capacity with pockets for
        manuals, additional hardware, and work papers. Adjustable protective straps
        and removable pocket for power supply and cables.'
        , 39,2
        , to_yminterval('+01-00')
        , 103095
        , 'orderable'
        , 87
        , 70
        , 'http://www.supp-103095.com/cat/off/p2721.html');
        
        insert into oehr_product_information values 
        (2722
        , 'PC Bag - L/D'
        , 'Black Leather Computer Case - double laptop capacity with pockets for
        additional hardware or manuals and work papers. Adjustable protective straps
        and removable pockets for power supplies and cables. Double wide shoulder
        strap for comfort.'
        , 39,2
        , to_yminterval('+01-00')
        , 103095
        , 'orderable'
        , 112
        , 99
        , 'http://www.supp-103095.com/cat/off/p2722.html');
        
        insert into oehr_product_information values 
        (2725
        , 'Machine Oil'
        , 'Machine Oil for Lubrication of CD-ROM drive doors and slides.
        Self-cleaning adjustable nozzle for fine to medium flow.'
        , 39,1
        , to_yminterval('+00-00')
        , 103098
        , 'orderable'
        , 4
        , 3
        , 'http://www.supp-103098.com/cat/off/p2725.html');
        
        insert into oehr_product_information values 
        (2782
        , 'PC Bag - C/S'
        , 'Canvas Computer Case - single laptop capacity with pockets for manuals,
        additional hardware, and work papers. Adjustable protective straps and
        removable pocket for power supply and cables. Outside pocket with snap
        closure for easy access while travelling.'
        , 39,2
        , to_yminterval('+00-06')
        , 103095
        , 'orderable'
        , 62
        , 50
        , 'http://www.supp-103095.com/cat/off/p2782.html');
        
        insert into oehr_product_information values 
        (3187
        , 'Plastic Stock - B/HD'
        , 'Plastic Stock - Blue, high density.'
        , 39,1
        , to_yminterval('+00-00')
        , 103095
        , 'orderable'
        , 3
        , 2
        , 'http://www.supp-103095.com/cat/off/p3187.html');
        
        insert into oehr_product_information values 
        (3189
        , 'Plastic Stock - G'
        , 'Plastic Stock - Green, standard density.'
        , 39,1
        , to_yminterval('+00-00')
        , 103095
        , 'orderable'
        , 2
        , 1
        , 'http://www.supp-103095.com/cat/off/p3189.html');
        
        insert into oehr_product_information values 
        (3191
        , 'Plastic Stock - O'
        , 'Plastic Stock - Orange, standard density.'
        , 39,1
        , to_yminterval('+00-00')
        , 103095
        , 'orderable'
        , 2
        , 1
        , 'http://www.supp-103095.com/cat/off/p3191.html');
        
        insert into oehr_product_information values 
        (3193
        , 'Plastic Stock - W/HD'
        , 'Plastic Stock - White, high density.'
        , 39,1
        , to_yminterval('+00-00')
        , 103095
        , 'orderable'
        , 3
        , 2
        , 'http://www.supp-103095.com/cat/off/p3193.html');
      end;~';
   insert into wwv_sample_dmls (wwv_sample_dataset_id, language_cd, dml_name, install_seq, dml) 
   values (  3, 'en', 'Insert Into product information (Part 4)', 33, l_clob);

   l_clob :=q'~begin
        insert into oehr_product_descriptions values 
        (1726
        , 'US'
        , UNISTR(
        'LCD Monitor 11/PM'
        ), UNISTR(
        'Liquid Cristal Display 11 inch passive monitor.'));

        insert into oehr_product_descriptions values
        (2359
        , 'US'
        , UNISTR(
        'LCD Monitor 9/PM'
        ), UNISTR(
        'Liquid Cristal Display 9 inch passive monitor.'));

        insert into oehr_product_descriptions values
        (3060
        , 'US'
        , UNISTR(
        'Monitor 17/HR'
        ), UNISTR(
        'CRT Monitor 17 inch (16 viewable) high resolution. Exceptional image
        performance and the benefit of additional screen space.'));

        insert into oehr_product_descriptions values
        (2243
        , 'US'
        , UNISTR(
        'Monitor 17/HR/F'
        ), UNISTR(
        'Monitor 17 inch (16 viewable) high resolution, flat screen.'));

        insert into oehr_product_descriptions values
        (3057
        , 'US'
        , UNISTR(
        'Monitor 17/SD'
        ), UNISTR(
        'CRT Monitor 17 inch (16 viewable) short depth.'));

        insert into oehr_product_descriptions values
        (3061
        , 'US'
        , UNISTR(
        'Monitor 19/SD'
        ), UNISTR(
        'CRT Monitor 19 inch (18 viewable) short depth. High-contrast black
        screen coating: produces superior contrast and grayscale performance.
        '));

        insert into oehr_product_descriptions values
        (2245
        , 'US'
        , UNISTR(
        'Monitor 19/SD/M'
        ), UNISTR(
        'Monitor 19 (18 Viewable) short depth, Monochrome.'));

        insert into oehr_product_descriptions values
        (3065
        , 'US'
        , UNISTR(
        'Monitor 21/D'
        ), UNISTR(
        'CRT Monitor 21 inch (20 viewable). Digital OptiScan technology: supports
        resolutions up to 1600 x 1200 at 75Hz.'));

        insert into oehr_product_descriptions values
        (3331
        , 'US'
        , UNISTR(
        'Monitor 21/HR'
        ), UNISTR(
        '21 inch monitor (20 inch viewable) high resolution.'));

        insert into oehr_product_descriptions values
        (2252
        , 'US'
        , UNISTR(
        'Monitor 21/HR/M'
        ), UNISTR(
        'Monitor 21 inch (20 viewable) high resolution, monochrome.'));

        insert into oehr_product_descriptions values
        (3064
        , 'US'
        , UNISTR(
        'Monitor 21/SD'
        ), UNISTR(
        'Monitor 21 inch (20 viewable) short depth.'));

        insert into oehr_product_descriptions values
        (3155
        , 'US'
        , UNISTR(
        'Monitor Hinge - HD'
        ), UNISTR(
        'Monitor Hinge, heavy duty, maximum monitor weight 30 kg'));

        insert into oehr_product_descriptions values
        (3234
        , 'US'
        , UNISTR(
        'Monitor Hinge - STD'
        ), UNISTR(
        'Standard Monitor Hinge, maximum monitor weight 10 kg'));

        insert into oehr_product_descriptions values
        (3350
        , 'US'
        , UNISTR(
        'Plasma Monitor 10/LE/VGA'
        ), UNISTR(
        '10 inch low energy plasma monitor, VGA resolution'));

        insert into oehr_product_descriptions values
        (2236
        , 'US'
        , UNISTR(
        'Plasma Monitor 10/TFT/XGA'
        ), UNISTR(
        '10 inch TFT XGA flatscreen monitor for laptop computers'));

        insert into oehr_product_descriptions values
        (3054
        , 'US'
        , UNISTR(
        'Plasma Monitor 10/XGA'
        ), UNISTR(
        '10 inch standard plasma monitor, XGA resolution.'));

        insert into oehr_product_descriptions values
        (1782
        , 'US'
        , UNISTR(
        'Compact 400/DQ'
        ), UNISTR(
        '400 characters per second high-speed draft printer.'));

        insert into oehr_product_descriptions values
        (2430
        , 'US'
        , UNISTR(
        'Compact 400/LQ'
        ), UNISTR(
        '400 characters per second high-speed letter-quality printer.'));

        insert into oehr_product_descriptions values
        (1792
        , 'US'
        , UNISTR(
        'Industrial 600/DQ'
        ), UNISTR(
        'Wide carriage color capability 600 characters per second high-speed
        draft printer.'));

        insert into oehr_product_descriptions values
        (1791
        , 'US'
        , UNISTR(
        'Industrial 700/HD'
        ), UNISTR(
        '700 characters per second dot-matrix printer with harder body and dust
        protection for industrial uses.'));

        insert into oehr_product_descriptions values
        (2302
        , 'US'
        , UNISTR(
        'Inkjet B/6'
        ), UNISTR(
        'Inkjet Printer, black and white, 6 pages per minute, resolution 600x300
        dpi.'));

        insert into oehr_product_descriptions values
        (2453
        , 'US'
        , UNISTR(
        'Inkjet C/4'
        ), UNISTR(
        'Inkjet Printer, color (with two separate ink cartridges), 6 pages per
        minute black and white, 4 pages per minute color, resolution 600x300 dpi.'));

        insert into oehr_product_descriptions values
        (1797
        , 'US'
        , UNISTR(
        'Inkjet C/8/HQ'
        ), UNISTR(
        'Inkjet printer, color, 8 pages per minute, high resolution (photo
        quality).'));

        insert into oehr_product_descriptions values
        (2459
        , 'US'
        , UNISTR(
        'LaserPro 1200/8/BW'
        ), UNISTR(
        'Professional black and white laserprinter, resolution 1200 dpi, 8 pages
        per second.'));

        insert into oehr_product_descriptions values
        (3127
        , 'US'
        , UNISTR(
        'LaserPro 600/6/BW'
        ), UNISTR(
        'Standard black and white laserprinter, resolution 600 dpi, 6 pages per
        second.'));

        insert into oehr_product_descriptions values
        (2254
        , 'US'
        , UNISTR(
        'HD 10GB /I'
        ), UNISTR(
        '10GB capacity hard disk drive (internal).'));

        insert into oehr_product_descriptions values
        (3353
        , 'US'
        , UNISTR(
        'HD 10GB /R'
        ), UNISTR(
        '10GB Removable hard disk drive for 10GB Removable HD drive.'));

        insert into oehr_product_descriptions values
        (3069
        , 'US'
        , UNISTR(
        'HD 10GB /S'
        ), UNISTR(
        '10GB hard disk drive for Standard Mount.'));

        insert into oehr_product_descriptions values
        (2253
        , 'US'
        , UNISTR(
        'HD 10GB @5400 /SE'
        ), UNISTR(
        '10GB capacity hard disk drive (external) SCSI interface, 5400 RPM.'));

        insert into oehr_product_descriptions values
        (3354
        , 'US'
        , UNISTR(
        'HD 12GB /I'
        ), UNISTR(
        '12GB capacity harddisk drive (internal).'));

        insert into oehr_product_descriptions values
        (3072
        , 'US'
        , UNISTR(
        'HD 12GB /N'
        ), UNISTR(
        '12GB hard disk drive for Narrow Mount.'));

        insert into oehr_product_descriptions values
        (3334
        , 'US'
        , UNISTR(
        'HD 12GB /R'
        ), UNISTR(
        '12GB Removable hard disk drive.'));

        insert into oehr_product_descriptions values
        (3071
        , 'US'
        , UNISTR(
        'HD 12GB /S'
        ), UNISTR(
        '12GB hard disk drive for Standard Mount.'));

        insert into oehr_product_descriptions values
        (2255
        , 'US'
        , UNISTR(
        'HD 12GB @7200 /SE'
        ), UNISTR(
        '12GB capacity hard disk drive (external) SCSI, 7200 RPM.'));

        insert into oehr_product_descriptions values
        (1743
        , 'US'
        , UNISTR(
        'HD 18.2GB @10000 /E'
        ), UNISTR(
        'External hard drive disk - 18.2 GB, rated up to 10,000 RPM.'));

        insert into oehr_product_descriptions values
        (2382
        , 'US'
        , UNISTR(
        'HD 18.2GB@10000 /I'
        ), UNISTR(
        '18.2 GB SCSI hard disk @ 10000 RPM (internal).'));

        insert into oehr_product_descriptions values
        (3399
        , 'US'
        , UNISTR(
        'HD 18GB /SE'
        ), UNISTR(
        '18GB SCSI external hard disk drive.'));

        insert into oehr_product_descriptions values
        (3073
        , 'US'
        , UNISTR(
        'HD 6GB /I'
        ), UNISTR(
        '6GB capacity hard disk drive (internal).'));

        insert into oehr_product_descriptions values
        (1768
        , 'US'
        , UNISTR(
        'HD 8.2GB @5400'
        ), UNISTR(
        'Hard drive disk - 8.2 GB, rated up to 5,400 RPM.'));

        insert into oehr_product_descriptions values
        (2410
        , 'US'
        , UNISTR(
        'HD 8.4GB @5400'
        ), UNISTR(
        '8.4 GB hard disk @ 5400 RPM.'));

        insert into oehr_product_descriptions values
        (2257
        , 'US'
        , UNISTR(
        'HD 8GB /I'
        ), UNISTR(
        '8GB capacity hard disk drive (internal).'));

        insert into oehr_product_descriptions values
        (3400
        , 'US'
        , UNISTR(
        'HD 8GB /SE'
        ), UNISTR(
        '8GB capacity SCSI hard disk drive (external).'));

        insert into oehr_product_descriptions values
        (3355
        , 'US'
        , UNISTR(
        'HD 8GB /SI'
        ), UNISTR(
        '8GB SCSI hard disk drive, internal.'));

        insert into oehr_product_descriptions values
        (1772
        , 'US'
        , UNISTR(
        'HD 9.1GB @10000'
        ), UNISTR(
        'Hard disk drive - 9.1 GB, rated up to 10,000 RPM.'));

        insert into oehr_product_descriptions values
        (2414
        , 'US'
        , UNISTR(
        'HD 9.1GB @10000 /I'
        ), UNISTR(
        '9.1 GB SCSI hard disk @ 10000 RPM (internal).'));

        insert into oehr_product_descriptions values
        (2415
        , 'US'
        , UNISTR(
        'HD 9.1GB @7200'
        ), UNISTR(
        '9.1 GB hard disk @ 7200 RPM.'));

        insert into oehr_product_descriptions values
        (2395
        , 'US'
        , UNISTR(
        '32MB Cache /M'
        ), UNISTR(
        '32MB Mirrored cache memory (100-MHz Registered SDRAM)'));

        insert into oehr_product_descriptions values
        (1755
        , 'US'
        , UNISTR(
        '32MB Cache /NM'
        ), UNISTR(
        '32MB Non-Mirrored cache memory'));

        insert into oehr_product_descriptions values
        (2406
        , 'US'
        , UNISTR(
        '64MB Cache /M'
        ), UNISTR(
        '64MB Mirrored cache memory'));

        insert into oehr_product_descriptions values
        (2404
        , 'US'
        , UNISTR(
        '64MB Cache /NM'
        ), UNISTR(
        '64 MB Non-mirrored cache memory. FPM memory chips are
        implemented on 5 volt SIMMs, but are also available on
        3.3 volt DIMMs.'));

        insert into oehr_product_descriptions values
        (1770
        , 'US'
        , UNISTR(
        '8MB Cache /NM'
        ), UNISTR(
        '8MB Non-Mirrored Cache Memory (100-MHz Registered SDRAM)'));

        insert into oehr_product_descriptions values
        (2412
        , 'US'
        , UNISTR(
        '8MB EDO Memory'
        ), UNISTR(
        '8 MB 8x32 EDO SIM memory.'));

        insert into oehr_product_descriptions values
        (2378
        , 'US'
        , UNISTR(
        'DIMM - 128 MB'
        ), UNISTR(
        '128 MB DIMM memory.'));

        insert into oehr_product_descriptions values
        (3087
        , 'US'
        , UNISTR(
        'DIMM - 16 MB'
        ), UNISTR(
        'Citrus OLX DIMM - 16 MB capacity.'));

        insert into oehr_product_descriptions values
        (2384
        , 'US'
        , UNISTR(
        'DIMM - 1GB'
        ), UNISTR(
        'Memory DIMM: RAM - 1 GB capacity.'));

        insert into oehr_product_descriptions values
        (1749
        , 'US'
        , UNISTR(
        'DIMM - 256MB'
        ), UNISTR(
        'Memory DIMM: RAM 256 MB. (100-MHz Registered SDRAM)'));

        insert into oehr_product_descriptions values
        (1750
        , 'US'
        , UNISTR(
        'DIMM - 2GB'
        ), UNISTR(
        'Memory DIMM: RAM, 2 GB capacity.'));

        insert into oehr_product_descriptions values
        (2394
        , 'US'
        , UNISTR(
        'DIMM - 32MB'
        ), UNISTR(
        '32 MB DIMM Memory upgrade'));

        insert into oehr_product_descriptions values
        (2400
        , 'US'
        , UNISTR(
        'DIMM - 512 MB'
        ), UNISTR(
        '512 MB DIMM memory.'));

        insert into oehr_product_descriptions values
        (1763
        , 'US'
        , UNISTR(
        'DIMM - 64MB'
        ), UNISTR(
        'Memory DIMM: RAM, 64MB (100-MHz Unregistered ECC SDRAM)'));

        insert into oehr_product_descriptions values
        (2396
        , 'US'
        , UNISTR(
        'EDO - 32MB'
        ), UNISTR(
        'Memory EDO SIM: RAM, 32 MB (100-MHz Unregistered ECC SDRAM).'));

        insert into oehr_product_descriptions values
        (2272
        , 'US'
        , UNISTR(
        'RAM - 16 MB'
        ), UNISTR(
        'Memory SIMM: RAM - 16 MB capacity.'));

        insert into oehr_product_descriptions values
        (2274
        , 'US'
        , UNISTR(
        'RAM - 32 MB'
        ), UNISTR(
        'Memory SIMM: RAM - 32 MB capacity.'));

        insert into oehr_product_descriptions values
        (3090
        , 'US'
        , UNISTR(
        'RAM - 48 MB'
        ), UNISTR(
        'Random Access Memory, SIMM - 48 MB capacity.'));

        insert into oehr_product_descriptions values
        (1739
        , 'US'
        , UNISTR(
        'SDRAM - 128 MB'
        ), UNISTR(
        'SDRAM memory, 128 MB capacity.'));

        insert into oehr_product_descriptions values
        (3359
        , 'US'
        , UNISTR(
        'SDRAM - 16 MB'
        ), UNISTR(
        'SDRAM memory upgrade module, 16 MB.'));

        insert into oehr_product_descriptions values
        (3088
        , 'US'
        , UNISTR(
        'SDRAM - 32 MB'
        ), UNISTR(
        'SDRAM module with ECC - 32 MB capacity.'));

        insert into oehr_product_descriptions values
        (2276
        , 'US'
        , UNISTR(
        'SDRAM - 48 MB'
        ), UNISTR(
        'Memory SIMM: RAM - 48 MB. SDRAM can operate in burst mode.'));

        insert into oehr_product_descriptions values
        (3086
        , 'US'
        , UNISTR(
        'VRAM - 16 MB'
        ), UNISTR(
        'Citrus Video RAM module - 16 MB capacity.'));

        insert into oehr_product_descriptions values
        (3091
        , 'US'
        , UNISTR(
        'VRAM - 64 MB'
        ), UNISTR(
        'Citrus Video RAM memory module - 64 MB capacity.'));

        insert into oehr_product_descriptions values
        (1787
        , 'US'
        , UNISTR(
        'CPU D300'
        ), UNISTR(
        'Dual CPU @ 300Mhz. For light personal processing only, or file servers
        with less than 5 concurrent users. This product will probably become
        obsolete soon.'));

        insert into oehr_product_descriptions values
        (2439
        , 'US'
        , UNISTR(
        'CPU D400'
        ), UNISTR(
        'Dual CPU @ 400Mhz. Good price/performance ratio; for mid-size LAN
        file servers (up to 100 concurrent users).'));

        insert into oehr_product_descriptions values
        (1788
        , 'US'
        , UNISTR(
        'CPU D600'
        ), UNISTR(
        'Dual CPU @ 600Mhz. State of the art, high clock speed; for heavy
        load WAN servers (up to 200 concurrent users).'));

        insert into oehr_product_descriptions values
        (2375
        , 'US'
        , UNISTR(
        'GP 1024x768'
        ), UNISTR(
        'Graphics Processor, resolution 1024 X 768 pixels.'));

        insert into oehr_product_descriptions values
        (2411
        , 'US'
        , UNISTR(
        'GP 1280x1024'
        ), UNISTR(
        'Graphics Processor, resolution 1280 X 1024 pixels.'));

        insert into oehr_product_descriptions values
        (1769
        , 'US'
        , UNISTR(
        'GP 800x600'
        ), UNISTR(
        'Graphics processor, resolution 800 x 600 pixels.'));

        insert into oehr_product_descriptions values
        (2049
        , 'US'
        , UNISTR(
        'MB - S300'
        ), UNISTR(
        'PC type motherboard, 300 Series.'));

        insert into oehr_product_descriptions values
        (2751
        , 'US'
        , UNISTR(
        'MB - S450'
        ), UNISTR(
        'PC type motherboard, 450 Series.'));

        insert into oehr_product_descriptions values
        (3112
        , 'US'
        , UNISTR(
        'MB - S500'
        ), UNISTR(
        'PC type motherboard, 500 Series.'));
      end;~';
   insert into wwv_sample_dmls (wwv_sample_dataset_id, language_cd, dml_name, install_seq, dml) 
   values (  3, 'en', 'Insert Into product description (Part 1)', 40, l_clob);

   l_clob :=q'~begin
        insert into oehr_product_descriptions values
        (2752
        , 'US'
        , UNISTR(
        'MB - S550'
        ), UNISTR(
        'PC type motherboard for the 550 Series.'));

        insert into oehr_product_descriptions values
        (2293
        , 'US'
        , UNISTR(
        'MB - S600'
        ), UNISTR(
        'Motherboard, 600 Series.'));

        insert into oehr_product_descriptions values
        (3114
        , 'US'
        , UNISTR(
        'MB - S900/650+'
        ), UNISTR(
        'PC motherboard, 900 Series; standard motherboard
        for all models 650 and up.'));

        insert into oehr_product_descriptions values
        (3129
        , 'US'
        , UNISTR(
        'Sound Card STD'
        ), UNISTR(
        'Sound Card - standard version, with MIDI interface,
        line in/out, low impedance microphone input.'));

        insert into oehr_product_descriptions values
        (3133
        , 'US'
        , UNISTR(
        'Video Card /32'
        ), UNISTR(
        'Video Card, with 32MB cache memory.'));

        insert into oehr_product_descriptions values
        (2308
        , 'US'
        , UNISTR(
        'Video Card /E32'
        ), UNISTR(
        '3-D ELSA Video Card, with 32 MB memory.'));

        insert into oehr_product_descriptions values
        (2496
        , 'US'
        , UNISTR(
        'WSP DA-130'
        ), UNISTR(
        'Wide storage processor DA-130 for storage subunits.'));

        insert into oehr_product_descriptions values
        (2497
        , 'US'
        , UNISTR(
        'WSP DA-290'
        ), UNISTR(
        'Wide storage processor (model DA-290).'));

        insert into oehr_product_descriptions values
        (3106
        , 'US'
        , UNISTR(
        'KB 101/EN'
        ), UNISTR(
        'Standard PC/AT Enhanced Keyboard (101/102-Key).
        Input locale: English (US).'));

        insert into oehr_product_descriptions values
        (2289
        , 'US'
        , UNISTR(
        'KB 101/ES'
        ), UNISTR(
        'Standard PC/AT Enhanced Keyboard (101/102-Key).
        Input locale: Spanish.'));

        insert into oehr_product_descriptions values
        (3110
        , 'US'
        , UNISTR(
        'KB 101/FR'
        ), UNISTR(
        'Standard PC/AT Enhanced Keyboard (101/102-Key).
        Input locale: French.'));

        insert into oehr_product_descriptions values
        (3108
        , 'US'
        , UNISTR(
        'KB E/EN'
        ), UNISTR(
        'Ergonomic Keyboard with two separate key areas,
        detachable numeric pad. Key layout: English (US).'));

        insert into oehr_product_descriptions values
        (2058
        , 'US'
        , UNISTR(
        'Mouse +WP'
        ), UNISTR(
        'Combination of a mouse and a wrist pad for more
        comfortable typing and mouse operation.'));

        insert into oehr_product_descriptions values
        (2761
        , 'US'
        , UNISTR(
        'Mouse +WP/CL'
        ), UNISTR(
        'Set consisting of a mouse and wrist pad,
        with corporate logo'));

        insert into oehr_product_descriptions values
        (3117
        , 'US'
        , UNISTR(
        'Mouse C/E'
        ), UNISTR(
        'Ergonomic, cordless mouse. With track-ball
        for maximum comfort and ease of use.'));

        insert into oehr_product_descriptions values
        (2056
        , 'US'
        , UNISTR(
        'Mouse Pad /CL'
        ), UNISTR(
        'Standard mouse pad, with corporate logo'));

        insert into oehr_product_descriptions values
        (2211
        , 'US'
        , UNISTR(
        'Wrist Pad'
        ), UNISTR(
        'A foam strip to support your wrists when using a keyboard'));

        insert into oehr_product_descriptions values
        (2944
        , 'US'
        , UNISTR(
        'Wrist Pad /CL'
        ), UNISTR(
        'Wrist Pad with corporate logo'));

        insert into oehr_product_descriptions values
        (1742
        , 'US'
        , UNISTR(
        'CD-ROM 500/16x'
        ), UNISTR(
        'CD drive, read only, speed 16x, maximum capacity 500 MB.'));

        insert into oehr_product_descriptions values
        (2402
        , 'US'
        , UNISTR(
        'CD-ROM 600/E/24x'
        ), UNISTR(
        '600 MB external 24x speed CD-ROM drive (read only).'));

        insert into oehr_product_descriptions values
        (2403
        , 'US'
        , UNISTR(
        'CD-ROM 600/I/24x'
        ), UNISTR(
        '600 MB internal read only CD-ROM drive,
        reading speed 24x'));

        insert into oehr_product_descriptions values
        (1761
        , 'US'
        , UNISTR(
        'CD-ROM 600/I/32x'
        ), UNISTR(
        '600 MB Internal CD-ROM Drive, speed 32x (read only).'));

        insert into oehr_product_descriptions values
        (2381
        , 'US'
        , UNISTR(
        'CD-ROM 8x'
        ), UNISTR(
        'CD Writer, read only, speed 8x'));

        insert into oehr_product_descriptions values
        (2424
        , 'US'
        , UNISTR(
        'CDW 12/24'
        ), UNISTR(
        'CD Writer, speed 12x write, 24x read. Warning: will become obsolete very
        soon; this speed is not high enough anymore, and better alternatives are
        available for a reasonable price.'));

        insert into oehr_product_descriptions values
        (1781
        , 'US'
        , UNISTR(
        'CDW 20/48/E'
        ), UNISTR(
        'CD Writer, read 48x, write 20x'));

        insert into oehr_product_descriptions values
        (2264
        , 'US'
        , UNISTR(
        'CDW 20/48/I'
        ), UNISTR(
        'CD-ROM drive: read 20x, write 48x (internal)'));

        insert into oehr_product_descriptions values
        (2260
        , 'US'
        , UNISTR(
        'DFD 1.44/3.5'
        ), UNISTR(
        'Dual Floppy Drive - 1.44 MB - 3.5'));

        insert into oehr_product_descriptions values
        (2266
        , 'US'
        , UNISTR(
        'DVD 12x'
        ), UNISTR(
        'DVD-ROM drive: speed 12x'));

        insert into oehr_product_descriptions values
        (3077
        , 'US'
        , UNISTR(
        'DVD 8x'
        ), UNISTR(
        'DVD - ROM drive, 8x speed. Will probably become
        obsolete pretty soon...'));

        insert into oehr_product_descriptions values
        (2259
        , 'US'
        , UNISTR(
        'FD 1.44/3.5'
        ), UNISTR(
        'Floppy Drive - 1.44 MB High Density
        capacity - 3.5 inch chassis'));

        insert into oehr_product_descriptions values
        (2261
        , 'US'
        , UNISTR(
        'FD 1.44/3.5/E'
        ), UNISTR(
        'Floppy disk drive - 1.44 MB (high density)
        capacity - 3.5 inch (external)'));

        insert into oehr_product_descriptions values
        (3082
        , 'US'
        , UNISTR(
        'Modem - 56/90/E'
        ), UNISTR(
        'Modem - 56kb per second, v.90 PCI Global compliant.
        External; for power supply 110V.'));

        insert into oehr_product_descriptions values
        (2270
        , 'US'
        , UNISTR(
        'Modem - 56/90/I'
        ), UNISTR(
        'Modem - 56kb per second, v.90 PCI Global compliant.
        Internal, for standard chassis (3.5 inch).'));

        insert into oehr_product_descriptions values
        (2268
        , 'US'
        , UNISTR(
        'Modem - 56/H/E'
        ), UNISTR(
        'Standard Hayes compatible modem - 56kb per second, external.
        Power supply: 220V.'));

        insert into oehr_product_descriptions values
        (3083
        , 'US'
        , UNISTR(
        'Modem - 56/H/I'
        ), UNISTR(
        'Standard Hayes modem - 56kb per second, internal, for
         standard 3.5 inch chassis.'));

        insert into oehr_product_descriptions values
        (2374
        , 'US'
        , UNISTR(
        'Modem - C/100'
        ), UNISTR(
        'DOCSIS/EURODOCSIS 1.0/1.1-compliant external cable modem'));

        insert into oehr_product_descriptions values
        (1740
        , 'US'
        , UNISTR(
        'TD 12GB/DAT'
        ), UNISTR(
        'Tape drive - 12 gigabyte capacity, DAT format.'));

        insert into oehr_product_descriptions values
        (2409
        , 'US'
        , UNISTR(
        'TD 7GB/8'
        ), UNISTR(
        'Tape drive, 7GB capacity, 8mm cartridge tape.'));

        insert into oehr_product_descriptions values
        (2262
        , 'US'
        , UNISTR(
        'ZIP 100'
        ), UNISTR(
        'ZIP Drive, 100 MB capacity (external) plus cable for
        parallel port connection'));

        insert into oehr_product_descriptions values
        (2522
        , 'US'
        , UNISTR(
        'Battery - EL'
        ), UNISTR(
        'Extended life battery, for laptop computers'));

        insert into oehr_product_descriptions values
        (2278
        , 'US'
        , UNISTR(
        'Battery - NiHM'
        ), UNISTR(
        'Rechargeable NiHM battery for laptop computers'));

        insert into oehr_product_descriptions values
        (2418
        , 'US'
        , UNISTR(
        'Battery Backup (DA-130)'
        ), UNISTR(
        'Single-battery charger with LED indicators'));

        insert into oehr_product_descriptions values
        (2419
        , 'US'
        , UNISTR(
        'Battery Backup (DA-290)'
        ), UNISTR(
        'Two-battery charger with LED indicators'));

        insert into oehr_product_descriptions values
        (3097
        , 'US'
        , UNISTR(
        'Cable Connector - 32R'
        ), UNISTR(
        'Cable Connector - 32 pin ribbon'));

        insert into oehr_product_descriptions values
        (3099
        , 'US'
        , UNISTR(
        'Cable Harness'
        ), UNISTR(
        'Cable harness to organize and bundle computer wiring'));

        insert into oehr_product_descriptions values
        (2380
        , 'US'
        , UNISTR(
        'Cable PR/15/P'
        ), UNISTR(
        '15 foot parallel printer cable'));

        insert into oehr_product_descriptions values
        (2408
        , 'US'
        , UNISTR(
        'Cable PR/P/6'
        ), UNISTR(
        'Standard Centronics 6ft printer cable, parallel port'));

        insert into oehr_product_descriptions values
        (2457
        , 'US'
        , UNISTR(
        'Cable PR/S/6'
        ), UNISTR(
        'Standard RS232 serial printer cable, 6 feet'));

        insert into oehr_product_descriptions values
        (2373
        , 'US'
        , UNISTR(
        'Cable RS232 10/AF'
        ), UNISTR(
        '10 ft RS232 cable with F/F and 9F/25F adapters'));

        insert into oehr_product_descriptions values
        (1734
        , 'US'
        , UNISTR(
        'Cable RS232 10/AM'
        ), UNISTR(
        '10 ft RS232 cable with M/M and 9M/25M adapters'));

        insert into oehr_product_descriptions values
        (1737
        , 'US'
        , UNISTR(
        'Cable SCSI 10/FW/ADS'
        ), UNISTR(
        '10ft SCSI2 F/W Adapt to DSxx0 Cable'));

        insert into oehr_product_descriptions values
        (1745
        , 'US'
        , UNISTR(
        'Cable SCSI 20/WD->D'
        ), UNISTR(
        '20ft SCSI2 Wide Disk Store to Disk Store Cable'));

        insert into oehr_product_descriptions values
        (2982
        , 'US'
        , UNISTR(
        'Drive Mount - A'
        ), UNISTR(
        'Drive Mount assembly kit'));

        insert into oehr_product_descriptions values
        (3277
        , 'US'
        , UNISTR(
        'Drive Mount - A/T'
        ), UNISTR(
        'Drive Mount assembly kit for tower PC'));

        insert into oehr_product_descriptions values
        (2976
        , 'US'
        , UNISTR(
        'Drive Mount - D'
        ), UNISTR(
        'Drive Mount for desktop PC'));

        insert into oehr_product_descriptions values
        (3204
        , 'US'
        , UNISTR(
        'Envoy DS'
        ), UNISTR(
        'Envoy Docking Station'));

        insert into oehr_product_descriptions values
        (2638
        , 'US'
        , UNISTR(
        'Envoy DS/E'
        ), UNISTR(
        'Enhanced Envoy Docking Station'));

        insert into oehr_product_descriptions values
        (3020
        , 'US'
        , UNISTR(
        'Envoy IC'
        ), UNISTR(
        'Envoy Internet Computer, Plug&Play'));

        insert into oehr_product_descriptions values
        (1948
        , 'US'
        , UNISTR(
        'Envoy IC/58'
        ), UNISTR(
        'Internet computer with built-in 58K modem'));

        insert into oehr_product_descriptions values
        (3003
        , 'US'
        , UNISTR(
        'Laptop 128/12/56/v90/110'
        ), UNISTR(
        'Envoy Laptop, 128MB memory, 12GB hard disk, v90 modem,
        110V power supply.'));

        insert into oehr_product_descriptions values
        (2999
        , 'US'
        , UNISTR(
        'Laptop 16/8/110'
        ), UNISTR(
        'Envoy Laptop, 16MB memory, 8GB hard disk,
        110V power supply (US only).'));

        insert into oehr_product_descriptions values
        (3000
        , 'US'
        , UNISTR(
        'Laptop 32/10/56'
        ), UNISTR(
        'Envoy Laptop, 32MB memory, 10GB hard disk, 56K Modem,
        universal power supply (switchable).'));

        insert into oehr_product_descriptions values
        (3001
        , 'US'
        , UNISTR(
        'Laptop 48/10/56/110'
        ), UNISTR(
        'Envoy Laptop, 48MB memory, 10GB hard disk, 56K modem,
        110V power supply.'));

        insert into oehr_product_descriptions values
        (3004
        , 'US'
        , UNISTR(
        'Laptop 64/10/56/220'
        ), UNISTR(
        'Envoy Laptop, 64MB memory, 10GB hard disk, 56K modem,
        220V power supply.'));

        insert into oehr_product_descriptions values
        (3391
        , 'US'
        , UNISTR(
        'PS 110/220'
        ), UNISTR(
        'Power Supply - switchable, 110V/220V'));

        insert into oehr_product_descriptions values
        (3124
        , 'US'
        , UNISTR(
        'PS 110V /T'
        ), UNISTR(
        'Power supply for tower PC, 110V'));

        insert into oehr_product_descriptions values
        (1738
        , 'US'
        , UNISTR(
        'PS 110V /US'
        ), UNISTR(
        '110 V Power Supply - US compatible'));

        insert into oehr_product_descriptions values
        (2377
        , 'US'
        , UNISTR(
        'PS 110V HS/US'
        ), UNISTR(
        '110 V hot swappable power supply - US compatible'));

        insert into oehr_product_descriptions values
        (2299
        , 'US'
        , UNISTR(
        'PS 12V /P'
        ), UNISTR(
        'Power Supply - 12v portable'));

        insert into oehr_product_descriptions values
        (3123
        , 'US'
        , UNISTR(
        'PS 220V /D'
        ), UNISTR(
        'Standard power supply, 220V, for desktop computers.'));

        insert into oehr_product_descriptions values
        (1748
        , 'US'
        , UNISTR(
        'PS 220V /EUR'
        ), UNISTR(
        '220 Volt Power supply type - Europe'));

        insert into oehr_product_descriptions values
        (2387
        , 'US'
        , UNISTR(
        'PS 220V /FR'
        ), UNISTR(
        '220V Power supply type - France'));

        insert into oehr_product_descriptions values
        (2370
        , 'US'
        , UNISTR(
        'PS 220V /HS/FR'
        ), UNISTR(
        '220V hot swappable power supply, for France.'));

        insert into oehr_product_descriptions values
        (2311
        , 'US'
        , UNISTR(
        'PS 220V /L'
        ), UNISTR(
        'Power supply for laptop computers, 220V'));

        insert into oehr_product_descriptions values
        (1733
        , 'US'
        , UNISTR(
        'PS 220V /UK'
        ), UNISTR(
        '220V Power supply type - United Kingdom'));

        insert into oehr_product_descriptions values
        (2878
        , 'US'
        , UNISTR(
        'Router - ASR/2W'
        ), UNISTR(
        'Special ALS Router - Approved Supplier required item with 2-way match'));

        insert into oehr_product_descriptions values
        (2879
        , 'US'
        , UNISTR(
        'Router - ASR/3W'
        ), UNISTR(
        'Special ALS Router - Approved Supplier required item with 3-way match'));

        insert into oehr_product_descriptions values
        (2152
        , 'US'
        , UNISTR(
        'Router - DTMF4'
        ), UNISTR(
        'DTMF 4 port router'));

        insert into oehr_product_descriptions values
        (3301
        , 'US'
        , UNISTR(
        'Screws <B.28.P>'
        ), UNISTR(
        'Screws: Brass, size 28mm, Phillips head. Plastic box, contents 500.'));

        insert into oehr_product_descriptions values
        (3143
        , 'US'
        , UNISTR(
        'Screws <B.28.S>'
        ), UNISTR(
        'Screws: Brass, size 28mm, straight. Plastic box, contents 500.'));

        insert into oehr_product_descriptions values
        (2323
        , 'US'
        , UNISTR(
        'Screws <B.32.P>'
        ), UNISTR(
        'Screws: Brass, size 32mm, Phillips head. Plastic box, contents 400.'));

        insert into oehr_product_descriptions values
        (3134
        , 'US'
        , UNISTR(
        'Screws <B.32.S>'
        ), UNISTR(
        'Screws: Brass, size 32mm, straight. Plastic box, contents 400.'));

        insert into oehr_product_descriptions values
        (3139
        , 'US'
        , UNISTR(
        'Screws <S.16.S>'
        ), UNISTR(
        'Screws: Steel, size 16 mm, straight. Carton box, contents 750.'));

        insert into oehr_product_descriptions values
        (3300
        , 'US'
        , UNISTR(
        'Screws <S.32.P>'
        ), UNISTR(
        'Screws: Steel, size 32mm, Phillips head. Plastic box, contents 400.'));

        insert into oehr_product_descriptions values
        (2316
        , 'US'
        , UNISTR(
        'Screws <S.32.S>'
        ), UNISTR(
        'Screws: Steel, size 32mm, straight. Plastic box, contents 500.'));

        insert into oehr_product_descriptions values
        (3140
        , 'US'
        , UNISTR(
        'Screws <Z.16.S>'
        ), UNISTR(
        'Screws: Zinc, length 16mm, straight. Carton box, contents 750.'));

        insert into oehr_product_descriptions values
        (2319
        , 'US'
        , UNISTR(
        'Screws <Z.24.S>'
        ), UNISTR(
        'Screws: Zinc, size 24mm, straight. Carton box, contents 500.'));

        insert into oehr_product_descriptions values
        (2322
        , 'US'
        , UNISTR(
        'Screws <Z.28.P>'
        ), UNISTR(
        'Screws: Zinc, size 28 mm, Phillips head. Carton box, contents 850.'));

        insert into oehr_product_descriptions values
        (3178
        , 'US'
        , UNISTR(
        'Spreadsheet - SSP/V 2.0'
        ), UNISTR(
        'SmartSpread Spreadsheet, Professional Edition Version 2.0, for Vision
        Release 11.1 and 11.2. Shrink wrap includes CD-ROM containing advanced
        software and online documentation, plus printed manual, tutorial, and
        license registration.'));

        insert into oehr_product_descriptions values
        (3179
        , 'US'
        , UNISTR(
        'Spreadsheet - SSS/S 2.1'
        ), UNISTR(
        'SmartSpread Spreadsheet, Standard Edition Version 2.1, for SPNIX Release
        4.0.'));

        insert into oehr_product_descriptions values
        (3182
        , 'US'
        , UNISTR(
        'Word Processing - SWP/V 4.5'
        ), UNISTR(
        'SmartWord Word Processor, Professional Edition Version 4.5, for Vision
        Release 11.x.'));

        insert into oehr_product_descriptions values
        (3183
        , 'US'
        , UNISTR(
        'Word Processing - SWS/V 4.5'
        ), UNISTR(
        'SmartWord Word Processor, Standard Edition Version 4.5, for Vision
        Release 11.x.'));

        insert into oehr_product_descriptions values
        (3197
        , 'US'
        , UNISTR(
        'Spreadsheet - SSS/V 2.1'
        ), UNISTR(
        'SmartSpread Spreadsheet, Standard Edition Version 2.1, for Vision
        Release 11.1 and 11.2.'));

        insert into oehr_product_descriptions values
        (3255
        , 'US'
        , UNISTR(
        'Spreadsheet - SSS/CD 2.2B'
        ), UNISTR(
        'SmartSpread Spreadsheet, Standard Edition, Beta Version 2.2, for
        SPNIX Release 4.1. CD-ROM only.'));

        insert into oehr_product_descriptions values
        (3256
        , 'US'
        , UNISTR(
        'Spreadsheet - SSS/V 2.0'
        ), UNISTR(
        'SmartSpread Spreadsheet, Standard Edition Version 2.0, for Vision
        Release 11.0.'));

        insert into oehr_product_descriptions values
        (3260
        , 'US'
        , UNISTR(
        'Word Processing - SWP/S 4.4'
        ), UNISTR(
        'SmartSpread Spreadsheet, Standard Edition Version 2.2, for SPNIX
        Release 4.x.'));

        insert into oehr_product_descriptions values
        (3262
        , 'US'
        , UNISTR(
        'Spreadsheet - SSS/S 2.2'
        ), UNISTR(
        'SmartSpread Spreadsheet, Standard Edition Version 2.2, for SPNIX
        Release 4.1.'));

        insert into oehr_product_descriptions values
        (3361
        , 'US'
        , UNISTR(
        'Spreadsheet - SSP/S 1.5'
        ), UNISTR(
        'SmartSpread Spreadsheet, Standard Edition Version 1.5, for SPNIX
        Release 3.3.'));

        insert into oehr_product_descriptions values
        (1799
        , 'US'
        , UNISTR(
        'SPNIX3.3 - SL'
        ), UNISTR(
        'Operating System Software: SPNIX V3.3 - Base Server License. Includes
        10 general licenses for system administration, developers, or users. No
        network user licensing. '));

        insert into oehr_product_descriptions values
        (1801
        , 'US'
        , UNISTR(
        'SPNIX3.3 - AL'
        ), UNISTR(
        'Operating System Software: SPNIX V3.3 - Additional system
        administrator license, including network access.'));

        insert into oehr_product_descriptions values
        (1803
        , 'US'
        , UNISTR(
        'SPNIX3.3 - DL'
        ), UNISTR(
        'Operating System Software: SPNIX V3.3 - Additional developer license.'));

        insert into oehr_product_descriptions values
        (1804
        , 'US'
        , UNISTR(
        'SPNIX3.3 - UL/N'
        ), UNISTR(
        'Operating System Software: SPNIX V3.3 - Additional user license with
        network access.'));

        insert into oehr_product_descriptions values
        (1805
        , 'US'
        , UNISTR(
        'SPNIX3.3 - UL/A'
        ), UNISTR(
        'Operating System Software: SPNIX V3.3 - Additional user license class A.'));

        insert into oehr_product_descriptions values
        (1806
        , 'US'
        , UNISTR(
        'SPNIX3.3 - UL/C'
        ), UNISTR(
        'Operating System Software: SPNIX V3.3 - Additional user license class C.'));

        insert into oehr_product_descriptions values
        (1808
        , 'US'
        , UNISTR(
        'SPNIX3.3 - UL/D'
        ), UNISTR(
        'Operating System Software: SPNIX V3.3 - Additional user license class D.'));

        insert into oehr_product_descriptions values
        (1820
        , 'US'
        , UNISTR(
        'SPNIX3.3 - NL'
        ), UNISTR(
        'Operating System Software: SPNIX V3.3 - Additional network access license.'));

        insert into oehr_product_descriptions values
        (1822
        , 'US'
        , UNISTR(
        'SPNIX4.0 - SL'
        ), UNISTR(
        'Operating System Software: SPNIX V4.0 - Base Server License. Includes
        10 general licenses for system administration, developers, or users. No
        network user licensing. '));

        insert into oehr_product_descriptions values
        (2422
        , 'US'
        , UNISTR(
        'SPNIX4.0 - SAL'
        ), UNISTR(
        'Operating System Software: SPNIX V4.0 - Additional system
        administrator license, including network access.'));

        insert into oehr_product_descriptions values
        (2452
        , 'US'
        , UNISTR(
        'SPNIX4.0 - DL'
        ), UNISTR(
        'Operating System Software: SPNIX V4.0 - Additional developer license.'));

        insert into oehr_product_descriptions values
        (2462
        , 'US'
        , UNISTR(
        'SPNIX4.0 - UL/N'
        ), UNISTR(
        'Operating System Software: SPNIX V4.0 - Additional user license with
        network access.'));

        insert into oehr_product_descriptions values
        (2464
        , 'US'
        , UNISTR(
        'SPNIX4.0 - UL/A'
        ), UNISTR(
        'Operating System Software: SPNIX V4.0 - Additional user license class A.'));

        insert into oehr_product_descriptions values
        (2467
        , 'US'
        , UNISTR(
        'SPNIX4.0 - UL/D'
        ), UNISTR(
        'Operating System Software: SPNIX V4.0 - Additional user license class D.'));

        insert into oehr_product_descriptions values
        (2468
        , 'US'
        , UNISTR(
        'SPNIX4.0 - UL/C'
        ), UNISTR(
        'Operating System Software: SPNIX V4.0 - Additional user license class C.'));

        insert into oehr_product_descriptions values
        (2470
        , 'US'
        , UNISTR(
        'SPNIX4.0 - NL'
        ), UNISTR(
        'Operating System Software: SPNIX V4.0 - Additional network access license.'));

        insert into oehr_product_descriptions values
        (2471
        , 'US'
        , UNISTR(
        'SPNIX3.3 SU'
        ), UNISTR(
        'Operating System Software: SPNIX V3.3 - Base Server License Upgrade
        to V4.0.'));

        insert into oehr_product_descriptions values
        (2492
        , 'US'
        , UNISTR(
        'SPNIX3.3 AU'
        ), UNISTR(
        'Operating System Software: SPNIX V3.3 - V4.0 upgrade; class A user.'));

        insert into oehr_product_descriptions values
        (2493
        , 'US'
        , UNISTR(
        'SPNIX3.3 C/DU'
        ), UNISTR(
        'Operating System Software: SPNIX V3.3 - V4.0 upgrade; class C or D user.'));

        insert into oehr_product_descriptions values
        (2494
        , 'US'
        , UNISTR(
        'SPNIX3.3 NU'
        ), UNISTR(
        'Operating System Software: SPNIX V3.3 - V4.0 upgrade;network access license.'));

        insert into oehr_product_descriptions values
        (2995
        , 'US'
        , UNISTR(
        'SPNIX3.3 SAU'
        ), UNISTR(
        'Operating System Software: SPNIX V3.3 - V4.0 upgrade; system
        administrator license.'));

        insert into oehr_product_descriptions values
        (3290
        , 'US'
        , UNISTR(
        'SPNIX3.3 DU'
        ), UNISTR(
        'Operating System Software: SPNIX V3.3 - V4.0 upgrade;developer license.'));

        insert into oehr_product_descriptions values
        (1778
        , 'US'
        , UNISTR(
        'C for SPNIX3.3 - 1 Seat'
        ), UNISTR(
        'C programming software for SPNIX V3.3 - single user'));

        insert into oehr_product_descriptions values
        (1779
        , 'US'
        , UNISTR(
        'C for SPNIX3.3 - Doc'
        ), UNISTR(
        'C programming language documentation
        , SPNIX V3.3'));

        insert into oehr_product_descriptions values
        (1780
        , 'US'
        , UNISTR(
        'C for SPNIX3.3 - Sys'
        ), UNISTR(
        'C programming software for SPNIX V3.3 - system compiler,
        libraries, linker'));

        insert into oehr_product_descriptions values
        (2371
        , 'US'
        , UNISTR(
        'C for SPNIX4.0 - Doc'
        ), UNISTR(
        'C programming language documentation, SPNIX V4.0'));

        insert into oehr_product_descriptions values
        (2423
        , 'US'
        , UNISTR(
        'C for SPNIX4.0 - 1 Seat'
        ), UNISTR(
        'C programming software for SPNIX V4.0 - single user'));

        insert into oehr_product_descriptions values
        (3501
        , 'US'
        , UNISTR(
        'C for SPNIX4.0 - Sys'
        ), UNISTR(
        'C programming software for SPNIX V4.0 - system compiler,
        libraries, linker'));

        insert into oehr_product_descriptions values
        (3502
        , 'US'
        , UNISTR(
        'C for SPNIX3.3 -Sys/U'
        ), UNISTR(
        'C programming software for SPNIX V3.3 - 4.0 Upgrade;system compiler, libraries, linker'));

        insert into oehr_product_descriptions values
        (3503
        , 'US'
        , UNISTR(
        'C for SPNIX3.3 - Seat/U'
        ), UNISTR(
        'C programming software for SPNIX V3.3 - 4.0 Upgrade - single user'));

        insert into oehr_product_descriptions values
        (1774
        , 'US'
        , UNISTR(
        'Base ISO CP - BL'
        ), UNISTR(
        'Base ISO Communication Package - Base License'));
      end;~';
   insert into wwv_sample_dmls (wwv_sample_dataset_id, language_cd, dml_name, install_seq, dml) 
   values (  3, 'en', 'Insert Into product descriptions (Part 2)', 41, l_clob);

   l_clob :=q'~begin
        insert into oehr_product_descriptions values
        (1775
        , 'US'
        , UNISTR(
        'Client ISO CP - S'
        ), UNISTR(
        'ISO Communication Package add-on license for additional SPNIX V3.3 client.'));

        insert into oehr_product_descriptions values
        (1794
        , 'US'
        , UNISTR(
        'OSI 8-16/IL'
        ), UNISTR(
        'OSI Layer 8 to 16 - Incremental License'));

        insert into oehr_product_descriptions values
        (1825
        , 'US'
        , UNISTR(
        'X25 - 1 Line License'
        ), UNISTR(
        'X25 network access control system, single user'));

        insert into oehr_product_descriptions values
        (2004
        , 'US'
        , UNISTR(
        'IC Browser - S'
        ), UNISTR(
        'IC Web Browser for SPNIX. Browser with network mail capability.'));

        insert into oehr_product_descriptions values
        (2005
        , 'US'
        , UNISTR(
        'IC Browser Doc - S'
        ), UNISTR(
        'Documentation set for IC Web Browser for SPNIX. Includes Installation
        Manual, Mail Server Administration Guide, and User Quick Reference.'));

        insert into oehr_product_descriptions values
        (2416
        , 'US'
        , UNISTR(
        'Client ISO CP - S'
        ), UNISTR(
        'ISO Communication Package add-on license for additional SPNIX V4.0 client.'));

        insert into oehr_product_descriptions values
        (2417
        , 'US'
        , UNISTR(
        'Client ISO CP - V'
        ), UNISTR(
        'ISO Communication Package add-on license for additional Vision client.'));

        insert into oehr_product_descriptions values
        (2449
        , 'US'
        , UNISTR(
        'OSI 1-4/IL'
        ), UNISTR(
        'OSI Layer 1 to 4 - Incremental License'));

        insert into oehr_product_descriptions values
        (3101
        , 'US'
        , UNISTR(
        'IC Browser - V'
        ), UNISTR(
        'IC Web Browser for Vision with manual. Browser with network mail capability.'));

        insert into oehr_product_descriptions values
        (3170
        , 'US'
        , UNISTR(
        'Smart Suite - V/SP'
        ), UNISTR(
        'Office Suite (SmartWrite, SmartArt, SmartSpread, SmartBrowse) for Vision.
        Spanish language software and user manuals.'));

        insert into oehr_product_descriptions values
        (3171
        , 'US'
        , UNISTR(
        'Smart Suite - S3.3/EN'
        ), UNISTR(
        'Office Suite (SmartWrite, SmartArt, SmartSpread, SmartBrowse) for SPNIX
        Version 3.3. English language software and user manuals.'));

        insert into oehr_product_descriptions values
        (3172
        , 'US'
        , UNISTR(
        'Graphics - DIK+'
        ), UNISTR(
        'Software Kit Graphics: Draw-It Kwik-Plus.'));

        insert into oehr_product_descriptions values
        (3173
        , 'US'
        , UNISTR(
        'Graphics - SA'
        ), UNISTR(
        'Software Kit Graphics: SmartArt. Professional graphics package for
        SPNIX with multiple line styles, textures, built-in shapes and common symbols.'));

        insert into oehr_product_descriptions values
        (3175
        , 'US'
        , UNISTR(
        'Project Management - S4.0'
        ), UNISTR(
        'Project Management Software, for SPNIX V4.0.'));

        insert into oehr_product_descriptions values
        (3176
        , 'US'
        , UNISTR(
        'Smart Suite - V/EN'
        ), UNISTR(
        'Office Suite (SmartWrite, SmartArt, SmartSpread, SmartBrowse) for
        Vision. English language software and user manuals.'));

        insert into oehr_product_descriptions values
        (3177
        , 'US'
        , UNISTR(
        'Smart Suite - V/FR'
        ), UNISTR(
        'Office Suite (SmartWrite, SmartArt, SmartSpread, SmartBrowse) for
        Vision. French language software and user manuals.'));

        insert into oehr_product_descriptions values
        (3245
        , 'US'
        , UNISTR(
        'Smart Suite - S4.0/FR'
        ), UNISTR(
        'Office Suite (SmartWrite, SmartArt, SmartSpread, SmartBrowse) for
        SPNIX V4.0. French language software and user manuals.'));

        insert into oehr_product_descriptions values
        (3246
        , 'US'
        , UNISTR(
        'Smart Suite - S4.0/SP'
        ), UNISTR(
        'Office Suite (SmartWrite, SmartArt, SmartSpread, SmartBrowse) for
        SPNIX V4.0. Spanish language software and user manuals.'));

        insert into oehr_product_descriptions values
        (3247
        , 'US'
        , UNISTR(
        'Smart Suite - V/DE'
        ), UNISTR(
        'Office Suite (SmartWrite, SmartArt, SmartSpread, SmartBrowse) for
        Vision. German language software and user manuals.'));

        insert into oehr_product_descriptions values
        (3248
        , 'US'
        , UNISTR(
        'Smart Suite - S4.0/DE'
        ), UNISTR(
        'Office Suite (SmartWrite, SmartArt, SmartSpread, SmartBrowse) for
        SPNIX V4.0. German language software and user manuals.'));

        insert into oehr_product_descriptions values
        (3250
        , 'US'
        , UNISTR(
        'Graphics - DIK'
        ), UNISTR(
        'Software Kit Graphics: Draw-It Kwik. Simple graphics package for
        Vision systems, with options to save in GIF, JPG, and BMP formats.'));

        insert into oehr_product_descriptions values
        (3251
        , 'US'
        , UNISTR(
        'Project Management - V'
        ), UNISTR(
        'Project Management Software, for Vision.'));

        insert into oehr_product_descriptions values
        (3252
        , 'US'
        , UNISTR(
        'Project Management - S3.3'
        ), UNISTR(
        'Project Management Software, for SPNIX V3.3.'));

        insert into oehr_product_descriptions values
        (3253
        , 'US'
        , UNISTR(
        'Smart Suite - S4.0/EN'
        ), UNISTR(
        'Office Suite (SmartWrite, SmartArt, SmartSpread, SmartBrowse) for
        SPNIX V4.0. English language software and user manuals.'));

        insert into oehr_product_descriptions values
        (3257
        , 'US'
        , UNISTR(
        'Web Browser - SB/S 2.1'
        ), UNISTR(
        'Software Kit Web Browser: SmartBrowse V2.1 for SPNIX V3.3. Includes
        context sensitive help files and online documentation.'));

        insert into oehr_product_descriptions values
        (3258
        , 'US'
        , UNISTR(
        'Web Browser - SB/V 1.0'
        ), UNISTR(
        'Software Kit Web Browser: SmartBrowse V2.1 for Vision. Includes
        context sensitive help files and online documentation.'));

        insert into oehr_product_descriptions values
        (3362
        , 'US'
        , UNISTR(
        'Web Browser - SB/S 4.0'
        ), UNISTR(
        'Software Kit Web Browser: SmartBrowse V4.0 for SPNIX V4.0. Includes
        context sensitive help files and online documentation.'));

        insert into oehr_product_descriptions values
        (2231
        , 'US'
        , UNISTR(
        'Desk - S/V'
        ), UNISTR(
        'Standard-sized desk; capitalizable, taxable item. Final finish is from
        veneer in stock at time of order, including oak, ash, cherry, and mahogany.'));

        insert into oehr_product_descriptions values
        (2335
        , 'US'
        , UNISTR(
        'Mobile phone'
        ), UNISTR(
        'Dual band mobile phone with low battery consumption. Lightweight,
        foldable, with socket for single earphone and spare battery compartment.'));

        insert into oehr_product_descriptions values
        (2350
        , 'US'
        , UNISTR(
        'Desk - W/48'
        ), UNISTR(
        'Desk - 48 inch white laminate without return; capitalizable, taxable item.'));

        insert into oehr_product_descriptions values
        (2351
        , 'US'
        , UNISTR(
        'Desk - W/48/R'
        ), UNISTR(
        'Desk - 60 inch white laminate with 48 inch return; capitalizable,
        taxable item.'));

        insert into oehr_product_descriptions values
        (2779
        , 'US'
        , UNISTR(
        'Desk - OS/O/F'
        ), UNISTR(
        'Executive-style oversized oak desk with file drawers. Final finish is
        customizable when ordered, light or dark oak stain,
        or natural hand rubbed clear.'));

        insert into oehr_product_descriptions values
        (3337
        , 'US'
        , UNISTR(
        'Mobile Web Phone'
        ), UNISTR(
        'Mobile phone including monthly fee for Web access. Slimline shape
        with leather-look carrying case and belt clip.'));

        insert into oehr_product_descriptions values
        (2091
        , 'US'
        , UNISTR(
        'Paper Tablet LW 8 1/2 x 11'
        ), UNISTR(
        'Paper tablet, lined, white, size 8 1/2 x 11 inch'));

        insert into oehr_product_descriptions values
        (2093
        , 'US'
        , UNISTR(
        'Pens - 10/FP'
        ), UNISTR(
        'Permanent ink pen dries quickly and is smear resistant.'));

        insert into oehr_product_descriptions values
        (2144
        , 'US'
        , UNISTR(
        'Card Organizer Cover'
        ), UNISTR(
        'Replacement cover for desk top style business card holder. Smoke
        grey (original color) or clear plastic.'));

        insert into oehr_product_descriptions values
        (2336
        , 'US'
        , UNISTR(
        'Business Cards Box - 250'
        ), UNISTR(
        'Business cards box, capacity 250. Use form BC110-2, Rev. 3/2000
        (hardcopy or online) when ordering and complete all fields marked
        with an asterisk.'));

        insert into oehr_product_descriptions values
        (2337
        , 'US'
        , UNISTR(
        'Business Cards - 1000/2L'
        ), UNISTR(
        'Business cards box, capacity 1000, 2-sided with different language on
        each side.'));

        insert into oehr_product_descriptions values
        (2339
        , 'US'
        , UNISTR(
        'Paper - Std Printer'
        ), UNISTR(
        '20 lb. 8.5x11 inch white laser printer paper (recycled),
        ten 500-sheet reams'));

        insert into oehr_product_descriptions values
        (2536
        , 'US'
        , UNISTR(
        'Business Cards - 250/2L'
        ), UNISTR(
        'Business cards box, capacity 250, 2-sided with different language on
        each side.'));

        insert into oehr_product_descriptions values
        (2537
        , 'US'
        , UNISTR(
        'Business Cards Box - 1000'
        ), UNISTR(
        'Business cards box, capacity 1000. Use form BC110-3, Rev. 3/2000
        (hardcopy or online) when ordering and complete all fields marked with
        an asterisk.'));

        insert into oehr_product_descriptions values
        (2783
        , 'US'
        , UNISTR(
        'Clips - Paper'
        ), UNISTR(
        'World brand paper clips set the standard for quality.10 boxes with 100
        clips each. #1 regular or jumbo, smooth or non-skid.'));

        insert into oehr_product_descriptions values
        (2808
        , 'US'
        , UNISTR(
        'Paper Tablet LY 8 1/2 x 11'
        ), UNISTR(
        'Paper Tablet, Lined, Yellow, size 8 1/2 x 11 inch'));

        insert into oehr_product_descriptions values
        (2810
        , 'US'
        , UNISTR(
        'Inkvisible Pens'
        ), UNISTR(
        'Rollerball pen is equipped with a smooth precision tip. See-through
        rubber grip allows for a visible ink supply and comfortable writing.
        4-pack with 1 each, black, blue, red, green.'));

        insert into oehr_product_descriptions values
        (2870
        , 'US'
        , UNISTR(
        'Pencil - Mech'
        ), UNISTR(
        'Ergonomically designed mechanical pencil for improved writing comfort.
        Refillable erasers and leads. Available in three lead sizes: .5mm (fine));.7mm (medium)); and .9mm (thick).'));

        insert into oehr_product_descriptions values
        (3051
        , 'US'
        , UNISTR(
        'Pens - 10/MP'
        ), UNISTR(
        'Permanent ink pen dries quickly and is smear resistant.'));

        insert into oehr_product_descriptions values
        (3150
        , 'US'
        , UNISTR(
        'Card Holder - 25'
        ), UNISTR(
        'Card Holder; heavy plastic business card holder with embossed corporate
        logo. Holds about 25 of your business cards, depending on card thickness.'));

        insert into oehr_product_descriptions values
        (3208
        , 'US'
        , UNISTR(
        'Pencils - Wood'
        ), UNISTR(
        'Box of 2 dozen wooden pencils. Specify lead type when ordering: 2H
        (double hard), H (hard), HB (hard black), B (soft black).'));

        insert into oehr_product_descriptions values
        (3209
        , 'US'
        , UNISTR(
        'Sharpener - Pencil'
        ), UNISTR(
        'Electric Pencil Sharpener Rugged steel cutters for long life.
        PencilSaver helps prevent over-sharpening. Non-skid rubber feet.
        Built-in pencil holder.'));

        insert into oehr_product_descriptions values
        (3224
        , 'US'
        , UNISTR(
        'Card Organizer - 250'
        ), UNISTR(
        'Portable holder for organizing business cards, capacity 250.'));

        insert into oehr_product_descriptions values
        (3225
        , 'US'
        , UNISTR(
        'Card Organizer - 1000'
        ), UNISTR(
        'Holder for organizing business cards with alphabet dividers; capacity
        1000.'));

        insert into oehr_product_descriptions values
        (3511
        , 'US'
        , UNISTR(
        'Paper - HQ Printer'
        ), UNISTR(
        'Quality paper for inkjet and laser printers tested to resist printer
        jams.'));

        insert into oehr_product_descriptions values
        (3515
        , 'US'
        , UNISTR(
        'Lead Replacement'
        ), UNISTR(
        'Refill leads for mechanical pencils. Each pack contains 25 leads and
        a replacement eraser. Available in three lead sizes: .5mm (fine)); .7mm
        (medium)); and .9mm (thick).'));

        insert into oehr_product_descriptions values
        (2986
        , 'US'
        , UNISTR(
        'Manual - Vision OS/2x +'
        ), UNISTR(
        'Manuals for Vision Operating System V 2.x and Vision Office Suite'));

        insert into oehr_product_descriptions values
        (3163
        , 'US'
        , UNISTR(
        'Manual - Vision Net6.3/US'
        ), UNISTR(
        'Vision Networking V6.3 Reference Manual. US version with advanced
        encryption.'));

        insert into oehr_product_descriptions values
        (3165
        , 'US'
        , UNISTR(
        'Manual - Vision Tools2.0'
        ), UNISTR(
        'Vision Business Tools Suite V2.0 Reference Manual. Includes installation,
        configuration, and user guide.'));

        insert into oehr_product_descriptions values
        (3167
        , 'US'
        , UNISTR(
        'Manual - Vision OS/2.x'
        ), UNISTR(
        'Vision Operating System V2.0/2.1/2/3 Reference Manual.'));

        insert into oehr_product_descriptions values
        (3216
        , 'US'
        , UNISTR(
        'Manual - Vision Net6.3'
        ), UNISTR(
        'Vision Networking V6.3 Reference Manual. Non-US version with basic
        encryption.'));

        insert into oehr_product_descriptions values
        (3220
        , 'US'
        , UNISTR(
        'Manual - Vision OS/1.2'
        ), UNISTR(
        'Vision Operating System V1.2 Reference Manual. Complete installation,
        configuration, management, and tuning information for Vision system
        administration.'));

        insert into oehr_product_descriptions values
        (1729
        , 'US'
        , UNISTR(
        'Chemicals - RCP'
        ), UNISTR(
        'Cleaning Chemicals - 3500 roller clean pads'));

        insert into oehr_product_descriptions values
        (1910
        , 'US'
        , UNISTR(
        'FG Stock - H'
        ), UNISTR(
        'Fiberglass Stock - heavy duty, 1 thick'));

        insert into oehr_product_descriptions values
        (1912
        , 'US'
        , UNISTR(
        'SS Stock - 3mm'
        ), UNISTR(
        'Stainless steel stock - 3mm. Can be predrilled for standard power
        supplies, motherboard holders, and hard drives.'));

        insert into oehr_product_descriptions values
        (1940
        , 'US'
        , UNISTR(
        'ESD Bracelet/Clip'
        ), UNISTR(
        'Electro static discharge bracelet with alligator clip for easy
        connection to computer chassis or other ground.'));

        insert into oehr_product_descriptions values
        (2030
        , 'US'
        , UNISTR(
        'Latex Gloves'
        ), UNISTR(
        'Latex Gloves for assemblers, chemical handlers, fitters. Heavy duty,
        safety orange, with textured grip on fingers and thumb.'));

        insert into oehr_product_descriptions values
        (2326
        , 'US'
        , UNISTR(
        'Plastic Stock - Y'
        ), UNISTR(
        'Plastic Stock - Yellow, standard quality.'));

        insert into oehr_product_descriptions values
        (2330
        , 'US'
        , UNISTR(
        'Plastic Stock - R'
        ), UNISTR(
        'Plastic Stock - Red, standard quality.'));

        insert into oehr_product_descriptions values
        (2334
        , 'US'
        , UNISTR(
        'Resin'
        ), UNISTR(
        'General purpose synthetic resin.'));

        insert into oehr_product_descriptions values
        (2340
        , 'US'
        , UNISTR(
        'Chemicals - SW'
        ), UNISTR(
        'Cleaning Chemicals - 3500 staticide wipes'));

        insert into oehr_product_descriptions values
        (2365
        , 'US'
        , UNISTR(
        'Chemicals - TCS'
        ), UNISTR(
        'Cleaning Chemical - 2500 transport cleaning sheets'));

        insert into oehr_product_descriptions values
        (2594
        , 'US'
        , UNISTR(
        'FG Stock - L'
        ), UNISTR(
        'Fiberglass Stock - light weight for internal heat shielding, 1/4 thick'));

        insert into oehr_product_descriptions values
        (2596
        , 'US'
        , UNISTR(
        'SS Stock - 1mm'
        ), UNISTR(
        'Stainless steel stock - 3mm. Can be predrilled for standard model
        motherboard and battery holders.'));

        insert into oehr_product_descriptions values
        (2631
        , 'US'
        , UNISTR(
        'ESD Bracelet/QR'
        ), UNISTR(
        'Electro Static Discharge Bracelet: 2 piece lead with quick release
        connector.'));

        insert into oehr_product_descriptions values
        (2721
        , 'US'
        , UNISTR(
        'PC Bag - L/S'
        ), UNISTR(
        'Black Leather Computer Case - single laptop capacity with pockets for
        manuals, additional hardware, and work papers.'));

        insert into oehr_product_descriptions values
        (2722
        , 'US'
        , UNISTR(
        'PC Bag - L/D'
        ), UNISTR(
        'Black Leather Computer Case - double laptop capacity with pockets for
        additional hardware or manuals and work papers.'));

        insert into oehr_product_descriptions values
        (2725
        , 'US'
        , UNISTR(
        'Machine Oil'
        ), UNISTR(
        'Machine Oil for Lubrication of CD-ROM drive doors and slides.
        Self-cleaning adjustable nozzle for fine to medium flow.'));

        insert into oehr_product_descriptions values
        (2782
        , 'US'
        , UNISTR(
        'PC Bag - C/S'
        ), UNISTR(
        'Canvas Computer Case - single laptop capacity with pockets for manuals,
        additional hardware, and work papers.'));

        insert into oehr_product_descriptions values
        (3187
        , 'US'
        , UNISTR(
        'Plastic Stock - B/HD'
        ), UNISTR(
        'Plastic Stock - Blue, high density.'));

        insert into oehr_product_descriptions values
        (3189
        , 'US'
        , UNISTR(
        'Plastic Stock - G'
        ), UNISTR(
        'Plastic Stock - Green, standard density.'));

        insert into oehr_product_descriptions values
        (3191
        , 'US'
        , UNISTR(
        'Plastic Stock - O'
        ), UNISTR(
        'Plastic Stock - Orange, standard density.'));

        insert into oehr_product_descriptions values
        (3193
        , 'US'
        , UNISTR(
        'Plastic Stock - W/HD'
        ), UNISTR(
        'Plastic Stock - White, high density.'
        ));
      end;~';
   insert into wwv_sample_dmls (wwv_sample_dataset_id, language_cd, dml_name, install_seq, dml) 
   values (  3, 'en', 'Insert Into product description (Part 3)', 42, l_clob);

   l_clob :=q'~begin
        insert into oehr_orders values
        (  2458
          ,TO_TIMESTAMP('16-08-99 02.34.12.234359 PM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'direct'
          ,101
          ,0
          ,78279.6
          ,153
          ,NULL); 
        
        insert into oehr_orders values
        (  2397
          ,TO_TIMESTAMP('19-11-99 03.41.54.696211 PM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'direct'
          ,102
          ,1
          ,42283.2
          ,154
          ,NULL); 
        
        insert into oehr_orders values
        (  2454
          ,TO_TIMESTAMP('02-10-99 04.49.34.678340 PM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'direct'
          ,103
          ,1
          ,6653.4
          ,154
          ,NULL); 
        
        insert into oehr_orders values
        (  2354
          ,TO_TIMESTAMP('14-07-00 05.18.23.234567 PM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'direct'
          ,104
          ,0
          ,46257
          ,155
          ,NULL); 
        
        insert into oehr_orders values
        (  2358
          ,TO_TIMESTAMP('08-01-00 06.03.12.654278 PM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'direct'
          ,105
          ,2
          ,7826
          ,155
          ,NULL); 
        
        insert into oehr_orders values
        (  2381
          ,TO_TIMESTAMP('14-05-00 07.59.08.843679 PM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'direct'
          ,106
          ,3
          ,23034.6
          ,156
          ,NULL); 
        
        insert into oehr_orders values
        (  2440
          ,TO_TIMESTAMP('31-08-99 08.53.06.008765 PM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'direct'
          ,107
          ,3
          ,70576.9
          ,156
          ,NULL); 
        
        insert into oehr_orders values
        (  2357
          ,TO_TIMESTAMP('08-01-98 09.19.44.123456 PM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'direct'
          ,108
          ,5
          ,59872.4
          ,158
          ,NULL); 
        
        insert into oehr_orders values
        (  2394
          ,TO_TIMESTAMP('10-02-00 10.22.35.564789 PM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'direct'
          ,109
          ,5
          ,21863
          ,158
          ,NULL); 
        
        insert into oehr_orders values
        (  2435
          ,TO_TIMESTAMP('02-09-99 10.22.53.134567 PM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'direct'
          ,144
          ,6
          ,62303
          ,159
          ,NULL); 
        
        insert into oehr_orders values
        (  2455
          ,TO_TIMESTAMP('20-09-99 10.34.11.456789 AM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'direct'
          ,145
          ,7
          ,14087.5
          ,160
          ,NULL); 
        
        insert into oehr_orders values
        (  2379
          ,TO_TIMESTAMP('16-05-99 01.22.24.234567 AM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'direct'
          ,146
          ,8
          ,17848.2
          ,161
          ,NULL); 
        
        insert into oehr_orders values
        (  2396
          ,TO_TIMESTAMP('02-02-98 02.34.56.345678 AM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'direct'
          ,147
          ,8
          ,34930
          ,161
          ,NULL); 
        
        insert into oehr_orders values
        (  2406
          ,TO_TIMESTAMP('29-06-99 03.41.20.098765 AM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'direct'
          ,148
          ,8
          ,2854.2
          ,161
          ,NULL); 
        
        insert into oehr_orders values
        (  2434
          ,TO_TIMESTAMP('13-09-99 04.49.30.647893 AM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'direct'
          ,149
          ,8
          ,268651.8
          ,161
          ,NULL); 
        
        insert into oehr_orders values
        (  2436
          ,TO_TIMESTAMP('02-09-99 05.18.04.378034 AM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'direct'
          ,116
          ,8
          ,6394.8
          ,161
          ,NULL); 
        
        insert into oehr_orders values
        (  2446
          ,TO_TIMESTAMP('27-07-99 06.03.08.302945 AM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'direct'
          ,117
          ,8
          ,103679.3
          ,161
          ,NULL); 
        
        insert into oehr_orders values
        (  2447
          ,TO_TIMESTAMP('27-07-00 07.59.10.223344 AM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'direct'
          ,101
          ,8
          ,33893.6
          ,161
          ,NULL); 
        
        insert into oehr_orders values
        (  2432
          ,TO_TIMESTAMP('14-09-99 08.53.40.223345 AM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'direct'
          ,102
          ,10
          ,10523
          ,163
          ,NULL); 
        
        insert into oehr_orders values
        (  2433
          ,TO_TIMESTAMP('13-09-99 09.19.00.654279 AM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'direct'
          ,103
          ,10
          ,78
          ,163
          ,NULL); 
        
        insert into oehr_orders values
        (  2355
          ,TO_TIMESTAMP('26-01-98 10.22.51.962632 AM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'online'
          ,104
          ,8
          ,94513.5
          ,NULL
          ,NULL); 
        
        insert into oehr_orders values
        (  2356
          ,TO_TIMESTAMP('26-01-00 10.22.41.934562 AM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'online'
          ,105
          ,5
          ,29473.8
          ,NULL
          ,NULL); 
        
        insert into oehr_orders values
        (  2359
          ,TO_TIMESTAMP('08-01-98 10.34.13.112233 PM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'online'
          ,106
          ,9
          ,5543.1
          ,NULL
          ,NULL); 
        
        insert into oehr_orders values
        (  2360
          ,TO_TIMESTAMP('14-11-99 01.22.31.223344 PM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'online'
          ,107
          ,4
          ,990.4
          ,NULL
          ,NULL); 
        
        insert into oehr_orders values
        (  2361
          ,TO_TIMESTAMP('13-11-99 02.34.21.986210 PM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'online'
          ,108
          ,8
          ,120131.3
          ,NULL
          ,NULL); 
        
        insert into oehr_orders values
        (  2362
          ,TO_TIMESTAMP('13-11-99 03.41.10.619477 PM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'online'
          ,109
          ,4
          ,92829.4
          ,NULL
          ,NULL); 
        
        insert into oehr_orders values
        (  2363
          ,TO_TIMESTAMP('23-10-99 04.49.56.346122 PM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'online'
          ,144
          ,0
          ,10082.3
          ,NULL
          ,NULL); 
        
        insert into oehr_orders values
        (  2364
          ,TO_TIMESTAMP('28-08-99 05.18.45.942399 PM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'online'
          ,145
          ,4
          ,9500
          ,NULL
          ,NULL); 
        
        insert into oehr_orders values
        (  2365
          ,TO_TIMESTAMP('28-08-99 06.03.34.003399 PM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'online'
          ,146
          ,9
          ,27455.3
          ,NULL
          ,NULL); 
        
        insert into oehr_orders values
        (  2366
          ,TO_TIMESTAMP('28-08-99 07.59.23.144778 PM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'online'
          ,147
          ,5
          ,37319.4
          ,NULL
          ,NULL); 
        
        insert into oehr_orders values
        (  2367
          ,TO_TIMESTAMP('27-06-00 08.53.32.335522 PM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'online'
          ,148
          ,10
          ,144054.8
          ,NULL
          ,NULL); 
        
        insert into oehr_orders values
        (  2368
          ,TO_TIMESTAMP('26-06-00 09.19.43.190089 PM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'online'
          ,149
          ,10
          ,60065
          ,NULL
          ,NULL); 
        
        insert into oehr_orders values
        (  2369
          ,TO_TIMESTAMP('26-06-99 10.22.54.009932 PM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'online'
          ,116
          ,0
          ,11097.4
          ,NULL
          ,NULL); 
        
        insert into oehr_orders values
        (  2370
          ,TO_TIMESTAMP('26-06-00 11.22.11.647398 PM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'online'
          ,117
          ,4
          ,126
          ,NULL
          ,NULL); 
        
        insert into oehr_orders values
        (  2371
          ,TO_TIMESTAMP('16-05-99 12.34.56.113356 AM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'online'
          ,118
          ,6
          ,79405.6
          ,NULL
          ,NULL); 
        
        insert into oehr_orders values
        (  2372
          ,TO_TIMESTAMP('27-02-99 01.22.33.356789 AM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'online'
          ,119
          ,9
          ,16447.2
          ,NULL
          ,NULL); 
        
        insert into oehr_orders values
        (  2373
          ,TO_TIMESTAMP('27-02-00 02.34.51.220065 AM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'online'
          ,120
          ,4
          ,416
          ,NULL
          ,NULL); 
        
        insert into oehr_orders values
        (  2374
          ,TO_TIMESTAMP('27-02-00 03.41.45.109654 AM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'online'
          ,121
          ,0
          ,4797
          ,NULL
          ,NULL); 
        
        insert into oehr_orders values
        (  2375
          ,TO_TIMESTAMP('26-02-99 04.49.50.459233 AM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'online'
          ,122
          ,2
          ,103834.4
          ,NULL
          ,NULL); 
        
        insert into oehr_orders values
        (  2376
          ,TO_TIMESTAMP('07-06-99 05.18.08.883310 AM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'online'
          ,123
          ,6
          ,11006.2
          ,NULL
          ,NULL); 
        
        insert into oehr_orders values
        (  2377
          ,TO_TIMESTAMP('07-06-99 06.03.01.001100 AM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'online'
          ,141
          ,5
          ,38017.8
          ,NULL
          ,NULL); 
        
        insert into oehr_orders values
        (  2378
          ,TO_TIMESTAMP('24-05-99 07.59.10.010101 AM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'online'
          ,142
          ,5
          ,25691.3
          ,NULL
          ,NULL); 
        
        insert into oehr_orders values
        (  2380
          ,TO_TIMESTAMP('16-05-99 08.53.02.909090 AM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'online'
          ,143
          ,3
          ,27132.6
          ,NULL
          ,NULL); 
        
        insert into oehr_orders values
        (  2382
          ,TO_TIMESTAMP('14-05-00 09.19.03.828321 AM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'online'
          ,144
          ,8
          ,71173
          ,NULL
          ,NULL); 
        
        insert into oehr_orders values
        (  2383
          ,TO_TIMESTAMP('12-05-00 10.22.30.545103 AM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'online'
          ,145
          ,8
          ,36374.7
          ,NULL
          ,NULL); 
        
        insert into oehr_orders values
        (  2384
          ,TO_TIMESTAMP('12-05-00 11.22.34.525972 AM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'online'
          ,146
          ,3
          ,29249.1
          ,NULL
          ,NULL); 
        
        insert into oehr_orders values
        (  2385
          ,TO_TIMESTAMP('08-12-99 12.34.11.331392 PM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'online'
          ,147
          ,4
          ,295892
          ,NULL
          ,NULL); 
        
        insert into oehr_orders values
        (  2386
          ,TO_TIMESTAMP('06-12-99 01.22.34.225609 PM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'online'
          ,148
          ,10
          ,21116.9
          ,NULL
          ,NULL); 
        
        insert into oehr_orders values
        (  2387
          ,TO_TIMESTAMP('11-03-99 02.34.56.536966 PM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'online'
          ,149
          ,5
          ,52758.9
          ,NULL
          ,NULL); 
        
        insert into oehr_orders values
        (  2388
          ,TO_TIMESTAMP('04-06-99 03.41.12.554435 PM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'online'
          ,150
          ,4
          ,282694.3
          ,NULL
          ,NULL); 
        
        insert into oehr_orders values
        (  2389
          ,TO_TIMESTAMP('04-06-00 04.49.43.546954 PM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'online'
          ,151
          ,4
          ,17620
          ,NULL
          ,NULL); 
        
        insert into oehr_orders values
        (  2390
          ,TO_TIMESTAMP('18-11-99 05.18.50.546851 PM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'online'
          ,152
          ,9
          ,7616.8
          ,NULL
          ,NULL); 
        
        insert into oehr_orders values
        (  2391
          ,TO_TIMESTAMP('27-02-98 06.03.03.828330 PM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'direct'
          ,153
          ,2
          ,48070.6
          ,156
          ,NULL); 
        
        insert into oehr_orders values
        (  2392
          ,TO_TIMESTAMP('21-07-99 07.59.57.571057 PM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'direct'
          ,154
          ,9
          ,26632
          ,161
          ,NULL); 
        
        insert into oehr_orders values
        (  2393
          ,TO_TIMESTAMP('10-02-00 08.53.19.528202 PM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'direct'
          ,155
          ,4
          ,23431.9
          ,161
          ,NULL); 
        
        insert into oehr_orders values
        (  2395
          ,TO_TIMESTAMP('02-02-98 09.19.11.227550 PM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'direct'
          ,156
          ,3
          ,68501
          ,163
          ,NULL); 
        
        insert into oehr_orders values
        (  2398
          ,TO_TIMESTAMP('19-11-99 10.22.53.224175 PM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'direct'
          ,157
          ,9
          ,7110.3
          ,163
          ,NULL); 
        
        insert into oehr_orders values
        (  2399
          ,TO_TIMESTAMP('19-11-99 11.22.38.340990 PM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'direct'
          ,158
          ,0
          ,25270.3
          ,161
          ,NULL); 
        
        insert into oehr_orders values
        (  2400
          ,TO_TIMESTAMP('10-07-99 12.34.29.559387 AM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'direct'
          ,159
          ,2
          ,69286.4
          ,161
          ,NULL); 
        
        insert into oehr_orders values
        (  2401
          ,TO_TIMESTAMP('10-07-99 01.22.53.554822 AM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'direct'
          ,160
          ,3
          ,969.2
          ,163
          ,NULL); 
        
        insert into oehr_orders values
        (  2402
          ,TO_TIMESTAMP('02-07-99 02.34.44.665170 AM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'direct'
          ,161
          ,8
          ,600
          ,154
          ,NULL); 
        
        insert into oehr_orders values
        (  2403
          ,TO_TIMESTAMP('01-07-99 03.49.13.615512 PM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'direct'
          ,162
          ,0
          ,220
          ,154
          ,NULL); 
        
        insert into oehr_orders values
        (  2404
          ,TO_TIMESTAMP('01-07-99 03.49.13.664085 PM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'direct'
          ,163
          ,6
          ,510
          ,158
          ,NULL); 
        
        insert into oehr_orders values
        (  2405
          ,TO_TIMESTAMP('01-07-99 03.49.13.678123 PM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'direct'
          ,164
          ,5
          ,1233
          ,159
          ,NULL); 
        
        insert into oehr_orders values
        (  2407
          ,TO_TIMESTAMP('29-06-99 06.03.21.526005 AM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'direct'
          ,165
          ,9
          ,2519
          ,155
          ,NULL); 
        
        insert into oehr_orders values
        (  2408
          ,TO_TIMESTAMP('29-06-99 07.59.31.333617 AM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'direct'
          ,166
          ,1
          ,309
          ,158
          ,NULL); 
        
        insert into oehr_orders values
        (  2409
          ,TO_TIMESTAMP('29-06-99 08.53.41.984501 AM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'direct'
          ,167
          ,2
          ,48
          ,154
          ,NULL); 
        
        insert into oehr_orders values
        (  2410
          ,TO_TIMESTAMP('24-05-00 09.19.51.985501 AM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'direct'
          ,168
          ,6
          ,45175
          ,156
          ,NULL); 
        
        insert into oehr_orders values
        (  2411
          ,TO_TIMESTAMP('24-05-99 10.22.10.548639 AM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'direct'
          ,169
          ,8
          ,15760.5
          ,156
          ,NULL); 
        
        insert into oehr_orders values
        (  2412
          ,TO_TIMESTAMP('29-03-98 11.22.09.509801 AM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'direct'
          ,170
          ,9
          ,66816
          ,158
          ,NULL); 
        
        insert into oehr_orders values
        (  2413
          ,TO_TIMESTAMP('29-03-00 12.34.04.525934 PM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'direct'
          ,101
          ,5
          ,48552
          ,161
          ,NULL); 
        
        insert into oehr_orders values
        (  2414
          ,TO_TIMESTAMP('29-03-99 01.22.40.536996 PM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'direct'
          ,102
          ,8
          ,10794.6
          ,153
          ,NULL); 
        
        insert into oehr_orders values
        (  2415
          ,TO_TIMESTAMP('29-03-97 02.34.50.545196 PM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'direct'
          ,103
          ,6
          ,310
          ,161
          ,NULL); 
        
        insert into oehr_orders values
        (  2416
          ,TO_TIMESTAMP('29-03-99 03.41.20.945676 PM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'direct'
          ,104
          ,6
          ,384
          ,160
          ,NULL); 
        
        insert into oehr_orders values
        (  2417
          ,TO_TIMESTAMP('20-03-99 04.49.10.974352 PM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'direct'
          ,105
          ,5
          ,1926.6
          ,163
          ,NULL); 
        
        insert into oehr_orders values
        (  2418
          ,TO_TIMESTAMP('20-03-96 05.18.21.862632 PM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'direct'
          ,106
          ,4
          ,5546.6
          ,163
          ,NULL); 
        
        insert into oehr_orders values
        (  2419
          ,TO_TIMESTAMP('20-03-99 06.03.32.764632 PM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'direct'
          ,107
          ,3
          ,31574
          ,160
          ,NULL); 
        
        insert into oehr_orders values
        (  2420
          ,TO_TIMESTAMP('13-03-99 07.59.43.666320 PM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'direct'
          ,108
          ,2
          ,29750
          ,160
          ,NULL); 
        
        insert into oehr_orders values
        (  2421
          ,TO_TIMESTAMP('12-03-99 08.53.54.562432 PM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'direct'
          ,109
          ,1
          ,72836
          ,NULL
          ,NULL); 
        
        insert into oehr_orders values
        (  2422
          ,TO_TIMESTAMP('16-12-99 09.19.55.462332 PM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'direct'
          ,144
          ,2
          ,11188.5
          ,153
          ,NULL); 
        
        insert into oehr_orders values
        (  2423
          ,TO_TIMESTAMP('21-11-99 11.22.33.362632 AM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'direct'
          ,145
          ,3
          ,10367.7
          ,160
          ,NULL); 
        
        insert into oehr_orders values
        (  2424
          ,TO_TIMESTAMP('21-11-99 11.22.33.263332 AM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'direct'
          ,146
          ,4
          ,13824
          ,153
          ,NULL); 
        
        insert into oehr_orders values
        (  2425
          ,TO_TIMESTAMP('17-11-98 12.34.22.162552 AM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'direct'
          ,147
          ,5
          ,1500.8
          ,163
          ,NULL); 
        
        insert into oehr_orders values
        (  2426
          ,TO_TIMESTAMP('17-11-98 01.22.11.262552 AM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'direct'
          ,148
          ,6
          ,7200
          ,NULL
          ,NULL); 
        
        insert into oehr_orders values
        (  2427
          ,TO_TIMESTAMP('10-11-99 02.34.22.362124 AM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'direct'
          ,149
          ,7
          ,9055
          ,163
          ,NULL); 
        
        insert into oehr_orders values
        (  2428
          ,TO_TIMESTAMP('10-11-99 03.41.34.463567 AM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'direct'
          ,116
          ,8
          ,14685.8
          ,NULL
          ,NULL); 
        
        insert into oehr_orders values
        (  2429
          ,TO_TIMESTAMP('10-11-99 04.49.25.526321 AM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'direct'
          ,117
          ,9
          ,50125
          ,154
          ,NULL); 
        
        insert into oehr_orders values
        (  2430
          ,TO_TIMESTAMP('02-10-99 05.18.36.663332 AM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'direct'
          ,101
          ,8
          ,29669.9
          ,159
          ,NULL); 
        
        insert into oehr_orders values
        (  2431
          ,TO_TIMESTAMP('14-09-98 06.03.04.763452 AM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'direct'
          ,102
          ,1
          ,5610.6
          ,163
          ,NULL); 
        
        insert into oehr_orders values
        (  2437
          ,TO_TIMESTAMP('01-09-98 07.59.15.826132 AM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'direct'
          ,103
          ,4
          ,13550
          ,163
          ,NULL); 
        
        insert into oehr_orders values
        (  2438
          ,TO_TIMESTAMP('01-09-99 08.53.26.934626 AM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'direct'
          ,104
          ,0
          ,5451
          ,154
          ,NULL); 
        
        insert into oehr_orders values
        (  2439
          ,TO_TIMESTAMP('31-08-99 09.19.37.811132 AM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'direct'
          ,105
          ,1
          ,22150.1
          ,159
          ,NULL); 
        
        insert into oehr_orders values
        (  2441
          ,TO_TIMESTAMP('01-08-00 10.22.48.734526 AM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'direct'
          ,106
          ,5
          ,2075.2
          ,160
          ,NULL); 
        
        insert into oehr_orders values
        (  2442
          ,TO_TIMESTAMP('27-07-90 11.22.59.662632 AM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'direct'
          ,107
          ,9
          ,52471.9
          ,154
          ,NULL); 
        
        insert into oehr_orders values
        (  2443
          ,TO_TIMESTAMP('27-07-90 12.34.16.562632 PM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'direct'
          ,108
          ,0
          ,3646
          ,154
          ,NULL); 
        
        insert into oehr_orders values
        (  2444
          ,TO_TIMESTAMP('27-07-99 01.22.27.462632 PM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'direct'
          ,109
          ,1
          ,77727.2
          ,155
          ,NULL); 
        
        insert into oehr_orders values
        (  2445
          ,TO_TIMESTAMP('27-07-90 02.34.38.362632 PM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'direct'
          ,144
          ,8
          ,5537.8
          ,158
          ,NULL); 
        
        insert into oehr_orders values
        (  2448
          ,TO_TIMESTAMP('18-06-99 03.41.49.262632 PM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'direct'
          ,145
          ,5
          ,1388
          ,158
          ,NULL); 
        
        insert into oehr_orders values
        (  2449
          ,TO_TIMESTAMP('13-06-99 04.49.07.162632 PM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'direct'
          ,146
          ,6
          ,86
          ,155
          ,NULL); 
        
        insert into oehr_orders values
        (  2450
          ,TO_TIMESTAMP('11-04-99 05.18.10.362632 PM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'direct'
          ,147
          ,3
          ,1636
          ,159
          ,NULL); 
        
        insert into oehr_orders values
        (  2451
          ,TO_TIMESTAMP('17-12-99 06.03.52.562632 PM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'direct'
          ,148
          ,7
          ,10474.6
          ,154
          ,NULL); 
        
        insert into oehr_orders values
        (  2452
          ,TO_TIMESTAMP('06-10-99 07.59.43.462632 PM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'direct'
          ,149
          ,5
          ,12589
          ,159
          ,NULL); 
        
        insert into oehr_orders values
        (  2453
          ,TO_TIMESTAMP('04-10-99 08.53.34.362632 PM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'direct'
          ,116
          ,0
          ,129
          ,153
          ,NULL); 
        
        insert into oehr_orders values
        (  2456
          ,TO_TIMESTAMP('07-11-98 08.53.25.989889 PM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'direct'
          ,117
          ,0
          ,3878.4
          ,163
          ,NULL); 
        
        insert into oehr_orders values
        (  2457
          ,TO_TIMESTAMP('31-10-99 10.22.16.162632 PM'
          ,'DD-MM-RR HH.MI.SS.FF AM'
          ,'NLS_DATE_LANGUAGE=American')
          ,'direct'
          ,118
          ,5
          ,21586.2
          ,159
          ,NULL);

        update oehr_orders
        set    sales_rep_id = null
        where  order_mode = 'online';
      end;~';
   insert into wwv_sample_dmls (wwv_sample_dataset_id, language_cd, dml_name, install_seq, dml) 
   values (  3, 'en', 'Insert Into orders', 50, l_clob); 

   l_clob :=q'~begin     
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2355, 1,2289,    46,200); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2356, 1,2264, 199.1, 38); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2357, 1,2211,   3.3,140); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2358, 1,1781, 226.6,  9); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2359, 1,2337, 270.6,  1); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2360, 1,2058,    23, 29); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2361, 1,2289,    46,180); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2362, 1,2289,    48,200); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2363, 1,2264, 199.1,  9); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2364, 1,1910,    14,  6);
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2365, 1,2289,    48, 92); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2366, 1,2359, 226.6,  8); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2367, 1,2289,    48, 99); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2354, 1,3106,    48, 61); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2368, 1,3106,    48,150); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2369, 1,3150,    18,  3);
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2370, 1,1910,    14,  9);
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2371, 1,2274,   157,  6); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2372, 1,3106,    48,  6);
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2373, 1,1820,    49,  8);
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2374, 1,2422,   150, 10); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2375, 1,3106,    42,140); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2376, 1,2270,    60, 14); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2377, 1,2289,    42,130); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2378, 1,2403, 113.3, 20); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2379, 1,3106,    42, 92); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2380, 1,3106,    42, 26); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2381, 1,3117,    38,110); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2382, 1,3106,    42,160); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2383, 1,2409, 194.7, 37); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2384, 1,2289,    43, 95); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2385, 1,2289,    43,200); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2386, 1,2330,   1.1,  7); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2387, 1,2211,   3.3, 52); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2388, 1,2289,    43,150); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2389, 1,3106,    43,180); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2390, 1,1910,    14,  4);
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2391, 1,1787,   101,  5); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2392, 1,3106,    43, 63); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2393, 1,3051,    12, 10); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2394, 1,3117,    41, 90); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2395, 1,2211,   3.3,110); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2396, 1,3106,    44,150); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2397, 1,2976,    52,  2);
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2398, 1,2471, 482.9,  5); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2399, 1,2289,    44,120); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2400, 1,2976,    52,  4);
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2401, 1,2492,    41,  4);
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2402, 1,2536,    75,  8);
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2403, 1,2522,    44,  5);
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2404, 1,2721,    85,  6);
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2405, 1,2638,   137,  9); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2406, 1,2721,    85,  5);
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2407, 1,2721,    85,  5);
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2408, 1,2751,    61,  3);
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2409, 1,2810,     6,  8); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2410, 1,2976,    46, 10); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2411, 1,3082,    81,  2);
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2412, 1,3106,    46,170); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2413, 1,3108,    77,200); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2414, 1,3208,   1.1,  8); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2415, 1,2751,    62,  5);
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2416, 1,2870,   4.4, 10); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2417, 1,2870,   4.4,  9); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2418, 1,3082,    75, 15); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2419, 1,3106,    46,150); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2420, 1,3106,    46,110); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2421, 1,3106,    46,160); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2422, 1,3106,    46, 18); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2423, 1,3220,    39,  8);
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2424, 1,3350,   693, 11); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2425, 1,3501, 492.8,  3); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2426, 1,3193,   2.2,  6); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2427, 1,2430,   173, 12); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2428, 1,3106,    42,  7);
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2429, 1,3106,    42,200); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2430, 1,3350,   693,  6); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2431, 1,3097,   2.2,  3); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2432, 1,2976,    49,  3);
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2433, 1,1910,    13,  6);
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2434, 1,2211,   3.3, 81); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2435, 1,2289,    48, 35); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2436, 1,3208,   1.1,  8); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2437, 1,2423,    83,  8);
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2438, 1,2995,    69,  3);
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2439, 1,1797, 316.8,  9); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2440, 1,2289,    48, 19); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2441, 1,2536,    80,  9);
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2442, 1,2402,   127, 26); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2443, 1,3106,    44,  3);
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2444, 1,3117,    36,110); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2445, 1,2270,    66,  5);
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2446, 1,2289,    48, 47); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2447, 1,2264, 199.1, 29); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2448, 1,3106,    44,  3);
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2449, 1,2522,    43,  2);
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2450, 1,3191,   1.1,  4); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2451, 1,1910,    13,  9);
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2452, 1,3117,    38,140); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2453, 1,2492,    43,  3);
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2454, 1,2289,    43,120); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2455, 1,2471, 482.9,  3); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2456, 1,2522,    40,  5);
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2457, 1,3108,    72, 36); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2458, 1,3117,    38,140); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2354, 2,3114,  96.8, 43); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2356, 2,2274, 148.5, 34); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2358, 2,1782,   125,  4); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2361, 2,2299,    76,180); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2362, 2,2299,    76,160); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2363, 2,2272,   129,  7); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2365, 2,2293,    99, 28); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2368, 2,3110,    42, 60); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2369, 2,3155,    43,  1);
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2372, 2,3108,    74,  2);
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2373, 2,1825,    24,  1);
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2374, 2,2423,    78,  6);
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2375, 2,3112,    71, 84); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2376, 2,2276, 236.5,  4); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2378, 2,2412,    95,  2);
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2380, 2,3108,    75, 18); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2381, 2,3124,    77, 44); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2382, 2,3110,    43, 64); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2384, 2,2299,    71, 48); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2386, 2,2334,   3.3,  5); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2388, 2,2293,    94, 90); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2389, 2,3112,    73, 18); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2390, 2,1912,    14,  2);
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2391, 2,1791, 262.9,  3); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2392, 2,3112,    73, 57); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2393, 2,3060,   295,  2); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2394, 2,3123,    77, 36); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2396, 2,3108,    76, 75); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2399, 2,2293,    94, 12); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2400, 2,2982,    41,  1);
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2401, 2,2496, 268.4,  3); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2406, 2,2725,   3.3,  4); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2408, 2,2761,    26,  1);
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2411, 2,3086,   208,  2); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2412, 2,3114,    98, 68); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2413, 2,3112,    75, 40); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2414, 2,3216,    30,  7);
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2416, 2,2878,   340,  1); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2418, 2,3090,   187, 12); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2419, 2,3114,    99, 45); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2420, 2,3110,    46, 11); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2421, 2,3108,    78,160); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2422, 2,3117,    41,  5);
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2423, 2,3224,    32,  3);
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2424, 2,3354,   541,  9); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2425, 2,3511,     9,  2); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2427, 2,2439,   121,  1); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2428, 2,3108,    76,  1);
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2429, 2,3108,    76, 40); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2430, 2,3353, 454.3,  5); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2431, 2,3106,    48,  1);
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2432, 2,2982,    43,  2);
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2435, 2,2299,    75,  4);
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2436, 2,3209,    13,  2);
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2437, 2,2430, 157.3,  4); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2438, 2,3000,  1748,  3); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2439, 2,1806,    45,  4);
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2440, 2,2293,    98,  2);
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2441, 2,2537, 193.6,  7); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2442, 2,2410, 350.9, 21); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2443, 2,3114,   101,  2); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2444, 2,3127, 488.4, 88); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2445, 2,2278,    49,  3);
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2447, 2,2266,   297, 23); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2448, 2,3114,    99,  0);
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2450, 2,3193,   2.2,  3); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2454, 2,2293,    99,  0);
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2457, 2,3123,    79, 14); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2458, 2,3123,    79,112); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2354, 3,3123,    79, 47); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2361, 3,2308,    53,182); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2362, 3,2311,    93,164); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2365, 3,2302, 133.1, 29); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2368, 3,3117,    38, 62); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2369, 3,3163,    32,  5);
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2372, 3,3110,    42,  7);
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2375, 3,3117,    38, 85); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2378, 3,2414, 438.9,  7); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2380, 3,3117,    38, 23); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2381, 3,3133,    44, 44); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2382, 3,3114,   100, 65); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2389, 3,3123,    80, 21); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2391, 3,1797,   348,  7); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2392, 3,3117,    38, 58); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2393, 3,3064,  1017,  5); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2394, 3,3124,    82, 39); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2396, 3,3110,    44, 79); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2399, 3,2299,    76, 15); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2400, 3,2986,   123,  4); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2410, 2,2982,    40,  5);
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2411, 3,3097,   2.2,  6); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2412, 3,3123,  71.5, 68); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2413, 3,3117,    35, 44); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2414, 3,3220,    41,  9);
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2418, 3,3097,   2.2, 13); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2419, 3,3123,  71.5, 48); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2420, 3,3114,   101, 15); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2421, 3,3112,    72,164); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2422, 3,3123,  71.5,  5); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2424, 3,3359,   111, 12); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2425, 3,3515,   1.1,  4); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2428, 3,3114,   101,  5); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2429, 3,3110,    45, 43); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2430, 3,3359,   111, 10); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2431, 3,3114,   101,  3); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2436, 3,3216,    30,  3);
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2439, 3,1820,    54,  9);
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2440, 3,2302,   150,  2); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2442, 3,2418,    60, 23); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2444, 3,3133,    43, 90); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2450, 3,3197,    44,  5);
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2454, 3,2299,    71,  3);
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2457, 3,3127, 488.4, 17); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2458, 3,3127, 488.4,114); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2354, 4,3129,    41, 47); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2361, 4,2311,  86.9,185); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2362, 4,2316,    22,168); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2365, 4,2308,    56, 29); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2366, 4,2373,     6,  7); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2367, 4,2302,   147, 32); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2369, 4,3165,    34, 10); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2371, 4,2293,    96,  8);
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2375, 4,3127, 488.4, 86); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2377, 4,2302,   147,119); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2378, 4,2417,    27, 11); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2379, 4,3114,    98, 14); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2380, 4,3127, 488.4, 24); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2381, 4,3139,    20, 45); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2382, 4,3117,    35, 66); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2383, 4,2418,    56, 45); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2386, 3,2340,    71, 14); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2389, 4,3129,    46, 22); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2391, 4,1799, 961.4, 10); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2393, 4,3069,   385,  8); 
      end;~';
   insert into wwv_sample_dmls (wwv_sample_dataset_id, language_cd, dml_name, install_seq, dml) 
   values (  3, 'en', 'Insert Into order items (Part 1)', 60, l_clob); 

   l_clob :=q'~begin     
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2394, 4,3129,    46, 41); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2396, 4,3114,   100, 83); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2397, 4,2986,   120,  8); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2399, 4,2302,   149, 17); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2410, 3,2986,   120,  6); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2411, 4,3099,   3.3,  7); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2412, 4,3127,   492, 72); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2413, 4,3127,   492, 44); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2414, 4,3234,    39, 11); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2420, 4,3123,    79, 20); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2421, 4,3117,    41,165); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2426, 4,3216,    30, 11); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2428, 4,3117,    41,  6);
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2429, 4,3123,    79, 46); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2430, 4,3362,    94, 10); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2431, 4,3117,    41,  7);
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2432, 3,2986,   122,  5); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2436, 4,3224,    32,  6);
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2439, 4,1822,1433.3, 13); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2442, 4,2422,   144, 25); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2443, 3,3124,    82,  6);
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2444, 4,3139,    21, 93); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2447, 3,2272,   121, 24); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2458, 4,3134,    17,115); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2354, 5,3139,    21, 48); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2355, 4,2308,    57,185); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2356, 5,2293,    98, 40); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2358, 5,1797, 316.8, 12); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2359, 5,2359,   249,  1); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2361, 5,2316,    22,187); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2365, 5,2311,    95, 29); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2366, 5,2382, 804.1, 10); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2368, 4,3123,    81, 70); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2372, 4,3123,    81, 10); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2374, 5,2449,    78, 15); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2375, 5,3133,    45, 88); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2376, 5,2293,    99, 13); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2377, 5,2311,    95,121); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2378, 5,2423,    79, 11); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2380, 5,3133,    46, 28); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2381, 5,3143,    15, 48); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2382, 5,3123,    79, 71); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2383, 5,2422,   146, 46); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2385, 5,2302, 133.1, 87); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2388, 5,2308,    56, 96); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2391, 5,1808,    55, 15); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2393, 5,3077, 260.7,  8); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2394, 5,3133,    46, 45); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2399, 5,2308,    56, 17); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2408, 5,2783,    10, 10); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2410, 4,2995,    68,  8);
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2411, 5,3101,    73,  8);
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2412, 5,3134,    18, 75); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2413, 5,3129,    46, 45); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2420, 5,3127,   496, 22); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2421, 5,3123,    80,168); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2422, 4,3127,   496,  9); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2427, 5,2457,   4.4,  6); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2428, 5,3123,    80,  8);
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2429, 5,3127,   497, 49); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2431, 5,3127,   498,  9); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2435, 5,2311,  86.9,  8); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2442, 5,2430,   173, 28); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2444, 5,3140,    19, 95); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2447, 4,2278,    50, 25); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2354, 6,3143,    16, 53); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2355, 5,2311,  86.9,188); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2356, 6,2299,    72, 44); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2358, 6,1803,    55, 13); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2365, 6,2316,    22, 34); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2366, 6,2394, 116.6, 11); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2367, 5,2308,    54, 39); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2368, 5,3127,   496, 70); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2371, 5,2299,    73, 15); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2372, 5,3127,   496, 13); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2375, 6,3134,    17, 90); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2376, 6,2299,    73, 17); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2378, 6,2424, 217.8, 15); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2380, 6,3140,    20, 30); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2382, 6,3127,   496, 71); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2383, 6,2430,   174, 50); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2384, 5,2316,    21, 58); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2391, 6,1820,    52, 18); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2392, 6,3124,    77, 63); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2393, 6,3082,    78, 10); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2394, 6,3134,    18, 45); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2399, 6,2311,  86.9, 20); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2400, 6,2999,   880, 16); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2411, 6,3106,    45, 11); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2412, 6,3139,    20, 79); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2418, 6,3110,    45, 20); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2419, 4,3129,    43, 57); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2421, 6,3129,    43,172); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2422, 5,3133,    46, 11); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2423, 5,3245, 214.5, 13); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2427, 6,2464,    66,  6);
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2428, 6,3127,   498, 12); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2429, 6,3133,    46, 52); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2431, 6,3129,    44, 11); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2434, 6,2236, 949.3, 84); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2435, 6,2316,    21, 10); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2440, 6,2311,  86.9,  7); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2442, 6,2439, 115.5, 30); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2444, 6,3143,    15, 97); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2445, 5,2293,    97, 11); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2448, 5,3133,    42, 11); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2452, 6,3139,    20, 10); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2354, 7,3150,    17, 58); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2355, 6,2322,    19,188); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2356, 7,2308,    58, 47); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2357, 7,2245,   462, 26); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2358, 7,1808,    55, 14); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2362, 7,2326,   1.1,173); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2363, 7,2299,    74, 25); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2365, 7,2319,    24, 38); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2366, 7,2395,   120, 12); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2368, 6,3129,    42, 72); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2372, 6,3134,    17, 17); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2375, 7,3143,    15, 93); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2376, 7,2302, 133.1, 21); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2379, 7,3127, 488.4, 23); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2380, 7,3143,    15, 31); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2382, 7,3129,    42, 76); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2383, 7,2439, 115.5, 54); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2384, 6,2322,    22, 59); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2387, 7,2243, 332.2, 20); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2391, 7,1822,1433.3, 23); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2392, 7,3133,    45, 66); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2393, 7,3086,   211, 13); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2394, 7,3140,    19, 48); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2395, 7,2243, 332.2, 27); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2397, 7,2999,   880, 16); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2399, 7,2316,    22, 24); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2400, 7,3003,2866.6, 19); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2412, 7,3143,    16, 80); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2414, 7,3246, 212.3, 18); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2419, 5,3133,    45, 61); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2420, 6,3133,    48, 29); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2423, 6,3246, 212.3, 14); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2427, 7,2470,    76,  6);
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2428, 7,3133,    48, 12); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2429, 7,3139,    21, 54); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2432, 6,2999,   880, 11); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2434, 7,2245,   462, 86); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2435, 7,2323,    18, 12); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2436, 7,3245, 214.5, 16); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2437, 7,2457,   4.4, 17); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2440, 7,2322,    23, 10); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2443, 6,3139,    20, 12); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2444, 7,3150,    17,100); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2445, 6,2299,    72, 14); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2448, 6,3134,    17, 14); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2450, 6,3216,    29, 11); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2452, 7,3143,    15, 12); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2454, 6,2308,    55, 12); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2455, 6,2496, 268.4, 32); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2456, 7,2537, 193.6, 19); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2354, 8,3163,    30, 61); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2355, 7,2323,    17,190); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2356, 8,2311,    95, 51); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2357, 8,2252, 788.7, 26); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2361, 8,2326,   1.1,194); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2362, 8,2334,   3.3,177); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2363, 8,2308,    57, 26); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2365, 8,2322,    19, 43); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2366, 8,2400,   418, 16); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2369, 7,3170, 145.2, 24); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2372, 7,3143,    15, 21); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2374, 8,2467,    79, 21); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2375, 8,3150,    17, 93); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2376, 8,2311,    95, 25); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2380, 8,3150,    17, 33); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2382, 8,3139,    21, 79); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2384, 7,2330,   1.1, 61); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2385, 8,2311,  86.9, 96); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2387, 8,2245,   462, 22); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2389, 7,3143,    15, 30); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2390, 8,1948, 470.8, 16); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2392, 8,3139,    21, 68); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2393, 8,3087, 108.9, 14); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2395, 8,2252, 788.7, 30); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2397, 8,3000,1696.2, 16); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2399, 8,2326,   1.1, 27); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2407, 8,2752,    86, 18); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2411, 7,3112,    72, 17); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2414, 8,3253, 206.8, 23); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2420, 7,3140,    19, 34); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2423, 7,3251,    26, 16); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2426, 8,3234,    34, 18); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2428, 8,3143,    16, 13); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2434, 8,2252, 788.7, 87); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2435, 8,2334,   3.3, 14); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2436, 8,3250,    27, 18); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2437, 8,2462,    76, 19); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2440, 8,2330,   1.1, 13); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2443, 7,3143,    15, 17); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2444, 8,3155,    43,104); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2448, 7,3139,    20, 15); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2450, 7,3220,    41, 14); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2451, 7,1948, 470.8, 22); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2452, 8,3150,    17, 13); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2454, 7,2316,    21, 13); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2457, 8,3150,    17, 27); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2458, 7,3143,    15,129); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2354, 9,3165,    37, 64); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2355, 8,2326,   1.1,192); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2356, 9,2316,    22, 55); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2357, 9,2257, 371.8, 29); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2360, 8,2093,   7.7, 42); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2361, 9,2334,   3.3,198); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2362, 9,2339,    25,179); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2363, 9,2311,  86.9, 29); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2364, 8,1948, 470.8, 20); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2365, 9,2326,   1.1, 44); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2366, 9,2406, 195.8, 20); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2367, 8,2322,    22, 45); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2369, 8,3176, 113.3, 24); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2371, 8,2316,    21, 21); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2375, 9,3155,    45, 98); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2376, 9,2316,    21, 27); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2377, 8,2319,    25,131); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2380, 9,3155,    45, 33); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2381, 8,3163,    35, 55); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2382, 9,3143,    15, 82); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2385, 9,2319,    25, 97); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2386, 8,2365,    77, 27); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2387, 9,2252, 788.7, 27); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2389, 8,3155,    46, 33); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2392, 9,3150,    18, 72); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2393, 9,3091,   278, 19); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2396, 9,3140,    19, 93); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2399, 9,2330,   1.1, 28); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2406, 8,2761,    26, 19); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2407, 9,2761,    26, 21); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2410, 7,3003,2866.6, 15); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2411, 8,3123,    75, 17); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2414, 9,3260,    50, 24); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2420, 8,3143,    15, 39); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2422, 8,3150,    17, 25); 
      end;~';
   insert into wwv_sample_dmls (wwv_sample_dataset_id, language_cd, dml_name, install_seq, dml) 
   values (  3, 'en', 'Insert Into order items (Part 2)', 61, l_clob); 

   l_clob :=q'~begin     
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2423, 8,3258,    78, 21); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2428, 9,3150,    17, 16); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2429, 8,3150,    17, 55); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2434, 9,2254, 408.1, 92); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2435, 9,2339,    25, 19); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2436, 9,3256,    36, 18); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2437, 9,2464,    64, 21); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2440, 9,2334,   3.3, 15); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2442, 9,2459, 624.8, 40); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2443, 8,3150,    18, 17); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2447, 8,2293,    97, 34); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2448, 8,3143,    16, 16); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2450, 8,3224,    32, 16); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2452, 9,3155,    44, 13); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2454, 8,2323,    18, 16); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2457, 9,3155,    44, 32); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2354,10,3167,    51, 68); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2355, 9,2330,   1.1,197); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2356,10,2323,    18, 55); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2357,10,2262,    95, 29); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2359, 8,2370,    91, 17); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2363,10,2319,    24, 31); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2365,10,2335,    97, 45); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2366,10,2409, 194.7, 22); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2367, 9,2326,   1.1, 48); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2368, 9,3143,    16, 75); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2369, 9,3187,   2.2, 24); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2371, 9,2323,    17, 24); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2375,10,3163,    30, 99); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2376,10,2319,    25, 32); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2377, 9,2326,   1.1,132); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2379,10,3139,    21, 34); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2380,10,3163,    32, 36); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2383,10,2457,   4.4, 62); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2386, 9,2370,    90, 28); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2387,10,2253, 354.2, 32); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2388,10,2330,   1.1,105); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2392,10,3155,    49, 77); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2393,10,3099,   3.3, 19); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2394,10,3155,    49, 61); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2395, 9,2255, 690.8, 34); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2396,10,3150,    17, 93); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2399,10,2335,   100, 33); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2411, 9,3124,    84, 17); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2419, 8,3150,    17, 69); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2421, 9,3143,    15,176); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2422, 9,3155,    43, 29); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2434,10,2257, 371.8, 94); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2435,10,2350,2341.9, 24); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2440,10,2337, 270.6, 19); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2442,10,2467,    80, 44); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2443, 9,3155,    43, 21); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2445, 9,2311,    95, 24); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2446, 9,2326,   1.1, 34); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2447, 9,2299,    76, 35); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2452,10,3165,    34, 18); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2454, 9,2334,   3.3, 18); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2354,11,3170, 145.2, 70); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2355,10,2339,    25,199); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2357,11,2268,    75, 32); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2359, 9,2373,     6, 17);
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2363,11,2323,    18, 34); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2365,11,2339,    25, 50); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2366,11,2415, 339.9, 24); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2367,10,2330,   1.1, 52); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2368,10,3155,    45, 75); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2369,10,3193,   2.2, 28); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2371,10,2334,   3.3, 26); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2372,10,3163,    30, 30); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2375,11,3165,    36,103); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2376,11,2326,   1.1, 33); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2377,10,2330,   1.1,136); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2379,11,3140,    19, 35); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2380,11,3167,    52, 37); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2383,11,2462,    75, 63); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2386,10,2375,    73, 32); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2395,10,2264, 199.1, 34); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2396,11,3155,    47, 98); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2398,11,2537, 193.6, 23); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2411,10,3127, 488.4, 18); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2413,11,3155,    47, 62); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2418,11,3140,    20, 31); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2419, 9,3155,    47, 72); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2421,10,3150,    17,176); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2440,11,2339,    25, 23); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2444,11,3165,    37,112); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2445,10,2319,    25, 27); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2446,10,2330,   1.1, 36); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2447,10,2302, 133.1, 37); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2452,11,3170, 145.2, 20); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2354,12,3176, 113.3, 72); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2359,10,2377,    96, 17); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2363,12,2326,   1.1, 37); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2365,12,2340,    72, 54); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2366,12,2419,    69, 24); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2367,11,2335,  91.3, 54); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2371,11,2339,    25, 29); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2372,11,3167,    54, 32); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2375,12,3171,   132,107); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2376,12,2334,   3.3, 36); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2378,12,2457,   4.4, 25); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2380,12,3176, 113.3, 40); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2381,11,3176, 113.3, 62); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2382,12,3163,    29, 89); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2385,12,2335,  91.3,106); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2386,11,2378, 271.7, 33); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2389,11,3165,    34, 43); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2395,11,2268,    71, 37); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2396,12,3163,    29,100); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2398,12,2594,     9, 27); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2410,10,3051,    12, 21); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2411,11,3133,    43, 23); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2412,12,3163,    30, 92); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2413,12,3163,    30, 66); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2419,10,3165,    35, 76); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2420,11,3163,    30, 45); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2422,10,3163,    30, 35); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2426,12,3248, 212.3, 26); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2427,12,2496, 268.4, 19); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2428,12,3170, 145.2, 24); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2429,11,3163,    30, 63); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2440,12,2350,2341.9, 24); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2444,12,3172,    37,112); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2445,11,2326,   1.1, 28); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2446,11,2337, 270.6, 37); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2447,11,2308,    54, 40); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2452,12,3172,    37, 20); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2457,12,3170, 145.2, 42); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2354,13,3182,    61, 77); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2357,12,2276, 236.5, 38); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2359,11,2380,   5.5, 17); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2361,12,2359,   248,208); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2362,12,2359,   248,189); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2363,13,2334,   3.3, 42); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2367,12,2350,2341.9, 54); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2369,11,3204,   123, 34); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2371,12,2350,2341.9, 32); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2372,12,3170, 145.2, 36); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2375,13,3176,   120,109); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2378,13,2459, 624.8, 25); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2380,13,3187,   2.2, 40); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2381,12,3183,    47, 63); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2382,13,3165,    37, 92); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2384,12,2359,   249, 77); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2385,13,2350,2341.9,109); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2386,12,2394, 116.6, 36); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2387,13,2268,    75, 42); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2388,13,2350,2341.9,112); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2389,12,3167,    52, 47); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2392,13,3165,    40, 81); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2393,13,3108,  69.3, 30); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2394,13,3167,    52, 68); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2395,12,2270,    64, 41); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2399,13,2359, 226.6, 38); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2404,13,2808,     0, 37); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2406,12,2782,    62, 31); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2411,12,3143,    15, 24); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2412,13,3167,    54, 94); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2417,13,2976,    51, 37); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2418,12,3150,    17, 37); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2419,11,3167,    54, 81); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2420,12,3171,   132, 47); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2421,11,3155,    43,185); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2422,11,3167,    54, 39); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2423,12,3290,    65, 33); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2426,13,3252,    25, 29); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2427,13,2522,    40, 22); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2428,13,3173,    86, 28); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2429,12,3165,    36, 67); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2430,13,3501, 492.8, 43); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2434,13,2268,    75,104); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2435,13,2365,    75, 33); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2436,13,3290,    63, 24); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2437,13,2496, 268.4, 35); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2440,13,2359, 226.6, 28); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2443,12,3165,    36, 31); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2444,13,3182,    63,115); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2446,12,2350,2341.9, 39); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2447,12,2311,    93, 44); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2452,13,3173,    80, 23); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2455,12,2536,    75, 54); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2457,13,3172,    36, 45); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2458,12,3163,    32,142); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2355,13,2359, 226.6,204); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2357,13,2289,    48, 41); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2359,12,2381,    97, 17); 
        insert into oehr_order_items(order_id,line_item_id,product_id,unit_price,quantity) values (2361,13,2365,    76,209); 
      end;~';
   insert into wwv_sample_dmls (wwv_sample_dataset_id, language_cd, dml_name, install_seq, dml) 
   values (  3, 'en', 'Insert Into order items (Part 3)', 62, l_clob); 

   l_clob :=q'~begin             
        insert into oehr_inventories values(1733,1,106); 
        insert into oehr_inventories values(1734,1,106); 
        insert into oehr_inventories values(1737,1,106); 
        insert into oehr_inventories values(1738,1,107); 
        insert into oehr_inventories values(1745,1,108); 
        insert into oehr_inventories values(1748,1,108); 
        insert into oehr_inventories values(2278,1,125); 
        insert into oehr_inventories values(2316,1,131); 
        insert into oehr_inventories values(2319,1,117); 
        insert into oehr_inventories values(2322,1,118); 
        insert into oehr_inventories values(2323,1,118); 
        insert into oehr_inventories values(2370,1,125); 
        insert into oehr_inventories values(2373,1,126); 
        insert into oehr_inventories values(2377,1,126); 
        insert into oehr_inventories values(2380,1,127); 
        insert into oehr_inventories values(2387,1,128); 
        insert into oehr_inventories values(2408,1,131); 
        insert into oehr_inventories values(2418,1,133); 
        insert into oehr_inventories values(2419,1,133); 
        insert into oehr_inventories values(2457,1,89); 
        insert into oehr_inventories values(2638,1,132); 
        insert into oehr_inventories values(2878,1,170); 
        insert into oehr_inventories values(2879,1,170); 
        insert into oehr_inventories values(3000,1,175); 
        insert into oehr_inventories values(3003,1,175); 
        insert into oehr_inventories values(3004,1,176); 
        insert into oehr_inventories values(3099,1,205); 
        insert into oehr_inventories values(3124,1,209); 
        insert into oehr_inventories values(3134,1,196); 
        insert into oehr_inventories values(3139,1,197); 
        insert into oehr_inventories values(3140,1,197); 
        insert into oehr_inventories values(3143,1,197); 
        insert into oehr_inventories values(3204,1,221); 
        insert into oehr_inventories values(3300,1,222); 
        insert into oehr_inventories values(3301,1,222); 
        insert into oehr_inventories values(3391,1,251); 
        insert into oehr_inventories values(1733,2,96); 
        insert into oehr_inventories values(1734,2,96); 
        insert into oehr_inventories values(1737,2,96); 
        insert into oehr_inventories values(1738,2,96); 
        insert into oehr_inventories values(1739,2,97); 
        insert into oehr_inventories values(1740,2,97); 
        insert into oehr_inventories values(1742,2,97); 
        insert into oehr_inventories values(1745,2,98); 
        insert into oehr_inventories values(1748,2,98); 
        insert into oehr_inventories values(1749,2,98); 
        insert into oehr_inventories values(1750,2,98); 
        insert into oehr_inventories values(1755,2,99); 
        insert into oehr_inventories values(1763,2,100); 
        insert into oehr_inventories values(1768,2,101); 
        insert into oehr_inventories values(1769,2,101); 
        insert into oehr_inventories values(1770,2,104); 
        insert into oehr_inventories values(1772,2,105); 
        insert into oehr_inventories values(1774,2,114); 
        insert into oehr_inventories values(1775,2,114); 
        insert into oehr_inventories values(1778,2,115); 
        insert into oehr_inventories values(1779,2,115); 
        insert into oehr_inventories values(1780,2,115); 
        insert into oehr_inventories values(1781,2,106); 
        insert into oehr_inventories values(1787,2,107); 
        insert into oehr_inventories values(1788,2,107); 
        insert into oehr_inventories values(1794,2,117); 
        insert into oehr_inventories values(1799,2,118); 
        insert into oehr_inventories values(1801,2,118); 
        insert into oehr_inventories values(1803,2,119); 
        insert into oehr_inventories values(1804,2,119); 
        insert into oehr_inventories values(1805,2,119); 
        insert into oehr_inventories values(1806,2,119); 
        insert into oehr_inventories values(1808,2,119); 
        insert into oehr_inventories values(1820,2,122); 
        insert into oehr_inventories values(1822,2,122); 
        insert into oehr_inventories values(1825,2,122); 
        insert into oehr_inventories values(2005,2,117); 
        insert into oehr_inventories values(2058,2,110); 
        insert into oehr_inventories values(2243,2,149); 
        insert into oehr_inventories values(2245,2,149); 
        insert into oehr_inventories values(2255,2,154); 
        insert into oehr_inventories values(2257,2,154); 
        insert into oehr_inventories values(2259,2,154); 
        insert into oehr_inventories values(2260,2,155); 
        insert into oehr_inventories values(2261,2,155); 
        insert into oehr_inventories values(2262,2,155); 
        insert into oehr_inventories values(2264,2,111); 
        insert into oehr_inventories values(2266,2,111); 
        insert into oehr_inventories values(2270,2,112); 
        insert into oehr_inventories values(2274,2,113); 
        insert into oehr_inventories values(2276,2,113); 
        insert into oehr_inventories values(2278,2,113); 
        insert into oehr_inventories values(2316,2,119); 
        insert into oehr_inventories values(2319,2,167); 
        insert into oehr_inventories values(2322,2,167); 
        insert into oehr_inventories values(2323,2,167); 
        insert into oehr_inventories values(2335,2,91); 
        insert into oehr_inventories values(2350,2,94); 
        insert into oehr_inventories values(2351,2,94); 
        insert into oehr_inventories values(2359,2,173); 
        insert into oehr_inventories values(2370,2,178); 
        insert into oehr_inventories values(2371,2,81); 
        insert into oehr_inventories values(2373,2,178); 
        insert into oehr_inventories values(2374,2,178); 
        insert into oehr_inventories values(2375,2,178); 
        insert into oehr_inventories values(2377,2,179); 
        insert into oehr_inventories values(2378,2,179); 
        insert into oehr_inventories values(2380,2,179); 
        insert into oehr_inventories values(2387,2,180); 
        insert into oehr_inventories values(2394,2,181); 
        insert into oehr_inventories values(2395,2,182); 
        insert into oehr_inventories values(2396,2,182); 
        insert into oehr_inventories values(2402,2,183); 
        insert into oehr_inventories values(2403,2,183); 
        insert into oehr_inventories values(2404,2,183); 
        insert into oehr_inventories values(2406,2,183); 
        insert into oehr_inventories values(2408,2,184); 
        insert into oehr_inventories values(2409,2,184); 
        insert into oehr_inventories values(2410,2,184); 
        insert into oehr_inventories values(2411,2,184); 
        insert into oehr_inventories values(2414,2,185); 
        insert into oehr_inventories values(2415,2,185); 
        insert into oehr_inventories values(2416,2,88); 
        insert into oehr_inventories values(2417,2,88); 
        insert into oehr_inventories values(2418,2,185); 
        insert into oehr_inventories values(2419,2,185); 
        insert into oehr_inventories values(2422,2,89); 
        insert into oehr_inventories values(2423,2,89); 
        insert into oehr_inventories values(2424,2,186); 
        insert into oehr_inventories values(2439,2,191); 
        insert into oehr_inventories values(2449,2,93); 
        insert into oehr_inventories values(2452,2,94); 
        insert into oehr_inventories values(2457,2,194); 
        insert into oehr_inventories values(2462,2,95); 
        insert into oehr_inventories values(2464,2,96); 
        insert into oehr_inventories values(2467,2,96); 
        insert into oehr_inventories values(2468,2,96); 
        insert into oehr_inventories values(2470,2,97); 
        insert into oehr_inventories values(2471,2,97); 
        insert into oehr_inventories values(2492,2,101); 
        insert into oehr_inventories values(2493,2,101); 
        insert into oehr_inventories values(2494,2,101); 
        insert into oehr_inventories values(2638,2,120); 
        insert into oehr_inventories values(2752,2,138); 
        insert into oehr_inventories values(2779,2,128); 
        insert into oehr_inventories values(2878,2,158); 
        insert into oehr_inventories values(2879,2,158); 
        insert into oehr_inventories values(3000,2,177); 
        insert into oehr_inventories values(3003,2,178); 
        insert into oehr_inventories values(3004,2,178); 
        insert into oehr_inventories values(3054,2,171); 
        insert into oehr_inventories values(3057,2,172); 
        insert into oehr_inventories values(3060,2,172); 
        insert into oehr_inventories values(3061,2,173); 
        insert into oehr_inventories values(3065,2,173); 
        insert into oehr_inventories values(3071,2,174); 
        insert into oehr_inventories values(3072,2,174); 
        insert into oehr_inventories values(3077,2,175); 
        insert into oehr_inventories values(3082,2,176); 
        insert into oehr_inventories values(3083,2,176); 
        insert into oehr_inventories values(3086,2,176); 
        insert into oehr_inventories values(3088,2,177); 
        insert into oehr_inventories values(3090,2,177); 
        insert into oehr_inventories values(3091,2,177); 
        insert into oehr_inventories values(3099,2,193); 
        insert into oehr_inventories values(3108,2,194); 
        insert into oehr_inventories values(3110,2,195); 
        insert into oehr_inventories values(3112,2,195); 
        insert into oehr_inventories values(3117,2,196); 
        insert into oehr_inventories values(3124,2,197); 
        insert into oehr_inventories values(3129,2,198); 
        insert into oehr_inventories values(3134,2,184); 
        insert into oehr_inventories values(3139,2,185); 
        insert into oehr_inventories values(3140,2,185); 
        insert into oehr_inventories values(3143,2,185); 
        insert into oehr_inventories values(3165,2,189); 
        insert into oehr_inventories values(3167,2,189); 
        insert into oehr_inventories values(3170,2,212); 
        insert into oehr_inventories values(3171,2,213); 
        insert into oehr_inventories values(3172,2,213); 
        insert into oehr_inventories values(3173,2,213); 
        insert into oehr_inventories values(3175,2,213); 
        insert into oehr_inventories values(3176,2,213); 
        insert into oehr_inventories values(3177,2,214); 
        insert into oehr_inventories values(3178,2,214); 
        insert into oehr_inventories values(3179,2,214); 
        insert into oehr_inventories values(3182,2,214); 
        insert into oehr_inventories values(3183,2,214); 
        insert into oehr_inventories values(3204,2,209); 
        insert into oehr_inventories values(3246,2,225); 
        insert into oehr_inventories values(3247,2,225); 
        insert into oehr_inventories values(3248,2,225); 
        insert into oehr_inventories values(3250,2,226); 
        insert into oehr_inventories values(3251,2,226); 
        insert into oehr_inventories values(3252,2,226); 
        insert into oehr_inventories values(3253,2,226); 
        insert into oehr_inventories values(3255,2,226); 
        insert into oehr_inventories values(3256,2,227); 
        insert into oehr_inventories values(3257,2,227); 
        insert into oehr_inventories values(3258,2,227); 
        insert into oehr_inventories values(3260,2,227); 
        insert into oehr_inventories values(3300,2,210); 
        insert into oehr_inventories values(3301,2,210); 
        insert into oehr_inventories values(3331,2,215); 
        insert into oehr_inventories values(3334,2,216); 
        insert into oehr_inventories values(3337,2,264); 
        insert into oehr_inventories values(3350,2,232); 
        insert into oehr_inventories values(3354,2,219); 
        insert into oehr_inventories values(3355,2,219); 
        insert into oehr_inventories values(3359,2,220); 
        insert into oehr_inventories values(3361,2,244); 
        insert into oehr_inventories values(3362,2,244); 
        insert into oehr_inventories values(3391,2,239); 
        insert into oehr_inventories values(3400,2,226); 
        insert into oehr_inventories values(3501,2,353); 
        insert into oehr_inventories values(3502,2,267); 
        insert into oehr_inventories values(3503,2,267); 
        insert into oehr_inventories values(1729,3,100); 
        insert into oehr_inventories values(1733,3,88); 
        insert into oehr_inventories values(1734,3,88); 
        insert into oehr_inventories values(1737,3,89); 
        insert into oehr_inventories values(1738,3,89); 
        insert into oehr_inventories values(1745,3,90); 
        insert into oehr_inventories values(1748,3,90); 
        insert into oehr_inventories values(1912,3,112); 
        insert into oehr_inventories values(1940,3,66); 
        insert into oehr_inventories values(2278,3,101); 
        insert into oehr_inventories values(2316,3,107); 
        insert into oehr_inventories values(2319,3,118); 
        insert into oehr_inventories values(2322,3,118); 
        insert into oehr_inventories values(2323,3,118); 
        insert into oehr_inventories values(2326,3,94); 
        insert into oehr_inventories values(2340,3,69); 
        insert into oehr_inventories values(2365,3,73); 
        insert into oehr_inventories values(2370,3,126); 
        insert into oehr_inventories values(2373,3,126); 
        insert into oehr_inventories values(2377,3,127); 
        insert into oehr_inventories values(2380,3,127); 
        insert into oehr_inventories values(2387,3,131); 
        insert into oehr_inventories values(2408,3,135); 
        insert into oehr_inventories values(2418,3,136); 
        insert into oehr_inventories values(2419,3,136); 
        insert into oehr_inventories values(2457,3,142); 
        insert into oehr_inventories values(2596,3,87); 
        insert into oehr_inventories values(2631,3,93); 
        insert into oehr_inventories values(2638,3,108); 
        insert into oehr_inventories values(2722,3,107); 
        insert into oehr_inventories values(2878,3,146); 
        insert into oehr_inventories values(2879,3,146); 
        insert into oehr_inventories values(3000,3,245); 
        insert into oehr_inventories values(3003,3,246); 
        insert into oehr_inventories values(3004,3,246); 
        insert into oehr_inventories values(3099,3,181); 
        insert into oehr_inventories values(3124,3,185); 
        insert into oehr_inventories values(3134,3,272); 
        insert into oehr_inventories values(3139,3,273); 
        insert into oehr_inventories values(3140,3,273); 
        insert into oehr_inventories values(3143,3,273); 
        insert into oehr_inventories values(3189,3,181); 
        insert into oehr_inventories values(3191,3,181); 
        insert into oehr_inventories values(3193,3,181); 
        insert into oehr_inventories values(3204,3,197); 
        insert into oehr_inventories values(3300,3,304); 
        insert into oehr_inventories values(3301,3,304); 
        insert into oehr_inventories values(3391,3,227); 
        insert into oehr_inventories values(1733,4,63); 
        insert into oehr_inventories values(1734,4,63); 
        insert into oehr_inventories values(1737,4,63); 
        insert into oehr_inventories values(1738,4,64); 
        insert into oehr_inventories values(1739,4,64); 
        insert into oehr_inventories values(1740,4,67); 
        insert into oehr_inventories values(1742,4,67); 
        insert into oehr_inventories values(1745,4,68); 
        insert into oehr_inventories values(1748,4,68); 
        insert into oehr_inventories values(1749,4,68); 
        insert into oehr_inventories values(1750,4,68); 
        insert into oehr_inventories values(1755,4,69); 
        insert into oehr_inventories values(1763,4,70); 
        insert into oehr_inventories values(1768,4,71); 
        insert into oehr_inventories values(1769,4,71); 
        insert into oehr_inventories values(1770,4,71); 
        insert into oehr_inventories values(1772,4,72); 
        insert into oehr_inventories values(1781,4,73); 
        insert into oehr_inventories values(1787,4,74); 
        insert into oehr_inventories values(1788,4,74); 
        insert into oehr_inventories values(2058,4,88); 
        insert into oehr_inventories values(2243,4,74); 
        insert into oehr_inventories values(2245,4,74); 
        insert into oehr_inventories values(2255,4,76); 
        insert into oehr_inventories values(2257,4,76); 
        insert into oehr_inventories values(2259,4,76); 
        insert into oehr_inventories values(2260,4,76); 
        insert into oehr_inventories values(2261,4,76); 
        insert into oehr_inventories values(2262,4,77); 
        insert into oehr_inventories values(2264,4,87); 
        insert into oehr_inventories values(2266,4,87); 
        insert into oehr_inventories values(2270,4,88); 
        insert into oehr_inventories values(2274,4,89); 
        insert into oehr_inventories values(2276,4,89); 
        insert into oehr_inventories values(2278,4,89); 
        insert into oehr_inventories values(2316,4,95); 
        insert into oehr_inventories values(2319,4,86); 
        insert into oehr_inventories values(2322,4,86); 
        insert into oehr_inventories values(2323,4,86); 
        insert into oehr_inventories values(2359,4,95); 
        insert into oehr_inventories values(2370,4,97); 
        insert into oehr_inventories values(2373,4,97); 
        insert into oehr_inventories values(2374,4,97); 
        insert into oehr_inventories values(2375,4,97); 
        insert into oehr_inventories values(2377,4,98); 
        insert into oehr_inventories values(2378,4,98); 
        insert into oehr_inventories values(2380,4,98); 
        insert into oehr_inventories values(2387,4,99); 
        insert into oehr_inventories values(2394,4,100); 
        insert into oehr_inventories values(2395,4,100); 
        insert into oehr_inventories values(2396,4,101); 
        insert into oehr_inventories values(2402,4,102); 
        insert into oehr_inventories values(2403,4,102); 
        insert into oehr_inventories values(2404,4,102); 
        insert into oehr_inventories values(2406,4,102); 
        insert into oehr_inventories values(2408,4,103); 
        insert into oehr_inventories values(2409,4,103); 
        insert into oehr_inventories values(2410,4,103); 
        insert into oehr_inventories values(2411,4,103); 
        insert into oehr_inventories values(2414,4,103); 
        insert into oehr_inventories values(2415,4,104); 
        insert into oehr_inventories values(2418,4,104); 
        insert into oehr_inventories values(2419,4,104); 
        insert into oehr_inventories values(2424,4,105); 
        insert into oehr_inventories values(2439,4,107); 
        insert into oehr_inventories values(2457,4,110); 
        insert into oehr_inventories values(2638,4,96); 
        insert into oehr_inventories values(2752,4,114); 
        insert into oehr_inventories values(2878,4,134); 
        insert into oehr_inventories values(2879,4,134); 
        insert into oehr_inventories values(3000,4,210); 
        insert into oehr_inventories values(3003,4,211); 
        insert into oehr_inventories values(3004,4,211); 
        insert into oehr_inventories values(3054,4,219); 
        insert into oehr_inventories values(3057,4,219); 
        insert into oehr_inventories values(3060,4,223); 
        insert into oehr_inventories values(3061,4,223); 
        insert into oehr_inventories values(3065,4,223); 
        insert into oehr_inventories values(3071,4,224); 
        insert into oehr_inventories values(3072,4,225); 
        insert into oehr_inventories values(3077,4,225); 
        insert into oehr_inventories values(3082,4,226); 
        insert into oehr_inventories values(3083,4,226); 
        insert into oehr_inventories values(3086,4,227); 
        insert into oehr_inventories values(3088,4,227); 
        insert into oehr_inventories values(3090,4,227); 
        insert into oehr_inventories values(3091,4,228); 
        insert into oehr_inventories values(3099,4,169); 
        insert into oehr_inventories values(3108,4,170); 
        insert into oehr_inventories values(3110,4,171); 
        insert into oehr_inventories values(3112,4,171); 
        insert into oehr_inventories values(3117,4,172); 
        insert into oehr_inventories values(3124,4,173); 
        insert into oehr_inventories values(3129,4,174); 
        insert into oehr_inventories values(3134,4,234); 
        insert into oehr_inventories values(3139,4,235); 
        insert into oehr_inventories values(3140,4,235); 
        insert into oehr_inventories values(3143,4,236); 
        insert into oehr_inventories values(3204,4,185); 
        insert into oehr_inventories values(3300,4,266); 
        insert into oehr_inventories values(3301,4,266); 
        insert into oehr_inventories values(3331,4,271); 
        insert into oehr_inventories values(3334,4,272); 
        insert into oehr_inventories values(3350,4,208); 
        insert into oehr_inventories values(3354,4,275); 
        insert into oehr_inventories values(3355,4,275); 
        insert into oehr_inventories values(3359,4,276); 
        insert into oehr_inventories values(3391,4,215); 
        insert into oehr_inventories values(3400,4,282); 
        insert into oehr_inventories values(1729,5,71); 
        insert into oehr_inventories values(1733,5,46); 
        insert into oehr_inventories values(1734,5,46); 
        insert into oehr_inventories values(1737,5,47); 
        insert into oehr_inventories values(1738,5,47); 
        insert into oehr_inventories values(1745,5,48); 
        insert into oehr_inventories values(1748,5,48); 
        insert into oehr_inventories values(1774,5,73); 
        insert into oehr_inventories values(1775,5,74); 
        insert into oehr_inventories values(1778,5,74); 
        insert into oehr_inventories values(1779,5,74); 
        insert into oehr_inventories values(1780,5,74); 
        insert into oehr_inventories values(1794,5,77); 
        insert into oehr_inventories values(1799,5,77); 
        insert into oehr_inventories values(1801,5,78); 
        insert into oehr_inventories values(1803,5,78); 
        insert into oehr_inventories values(1804,5,78); 
        insert into oehr_inventories values(1805,5,78); 
        insert into oehr_inventories values(1806,5,78); 
        insert into oehr_inventories values(1808,5,79); 
        insert into oehr_inventories values(1820,5,81); 
        insert into oehr_inventories values(1822,5,81); 
        insert into oehr_inventories values(1825,5,82); 
        insert into oehr_inventories values(1912,5,90); 
        insert into oehr_inventories values(1940,5,44); 
        insert into oehr_inventories values(2005,5,69); 
        insert into oehr_inventories values(2278,5,77); 
        insert into oehr_inventories values(2316,5,83); 
        insert into oehr_inventories values(2319,5,62); 
        insert into oehr_inventories values(2322,5,63); 
        insert into oehr_inventories values(2323,5,63); 
        insert into oehr_inventories values(2326,5,70); 
        insert into oehr_inventories values(2335,5,85); 
        insert into oehr_inventories values(2340,5,86); 
        insert into oehr_inventories values(2350,5,88); 
        insert into oehr_inventories values(2351,5,88); 
        insert into oehr_inventories values(2365,5,90); 
        insert into oehr_inventories values(2370,5,73); 
        insert into oehr_inventories values(2371,5,84); 
        insert into oehr_inventories values(2373,5,74); 
        insert into oehr_inventories values(2377,5,74); 
        insert into oehr_inventories values(2380,5,75); 
        insert into oehr_inventories values(2387,5,76); 
        insert into oehr_inventories values(2408,5,79); 
        insert into oehr_inventories values(2416,5,42); 
        insert into oehr_inventories values(2417,5,42); 
        insert into oehr_inventories values(2418,5,81); 
        insert into oehr_inventories values(2419,5,81); 
        insert into oehr_inventories values(2422,5,42); 
        insert into oehr_inventories values(2423,5,43); 
        insert into oehr_inventories values(2449,5,47); 
        insert into oehr_inventories values(2452,5,47); 
        insert into oehr_inventories values(2457,5,87); 
        insert into oehr_inventories values(2462,5,49); 
        insert into oehr_inventories values(2464,5,49); 
        insert into oehr_inventories values(2467,5,50); 
        insert into oehr_inventories values(2468,5,50); 
        insert into oehr_inventories values(2470,5,50); 
        insert into oehr_inventories values(2471,5,50); 
        insert into oehr_inventories values(2492,5,54); 
        insert into oehr_inventories values(2493,5,54); 
        insert into oehr_inventories values(2494,5,54); 
        insert into oehr_inventories values(2596,5,63); 
        insert into oehr_inventories values(2631,5,69); 
        insert into oehr_inventories values(2638,5,84); 
        insert into oehr_inventories values(2722,5,83); 
        insert into oehr_inventories values(2779,5,92); 
        insert into oehr_inventories values(2878,5,122); 
        insert into oehr_inventories values(2879,5,122); 
        insert into oehr_inventories values(3000,5,184); 
        insert into oehr_inventories values(3003,5,184); 
        insert into oehr_inventories values(3004,5,185); 
        insert into oehr_inventories values(3099,5,157); 
        insert into oehr_inventories values(3124,5,161); 
        insert into oehr_inventories values(3134,5,208); 
        insert into oehr_inventories values(3139,5,209); 
        insert into oehr_inventories values(3140,5,209); 
        insert into oehr_inventories values(3143,5,209); 
        insert into oehr_inventories values(3170,5,163); 
        insert into oehr_inventories values(3171,5,163); 
        insert into oehr_inventories values(3172,5,163); 
        insert into oehr_inventories values(3173,5,163); 
        insert into oehr_inventories values(3175,5,164); 
        insert into oehr_inventories values(3176,5,164); 
        insert into oehr_inventories values(3177,5,164); 
        insert into oehr_inventories values(3178,5,164); 
        insert into oehr_inventories values(3179,5,164); 
        insert into oehr_inventories values(3182,5,165); 
        insert into oehr_inventories values(3183,5,165); 
        insert into oehr_inventories values(3189,5,157); 
        insert into oehr_inventories values(3191,5,157); 
        insert into oehr_inventories values(3193,5,157); 
        insert into oehr_inventories values(3204,5,173); 
        insert into oehr_inventories values(3246,5,175); 
        insert into oehr_inventories values(3247,5,175); 
        insert into oehr_inventories values(3248,5,175); 
        insert into oehr_inventories values(3250,5,176); 
        insert into oehr_inventories values(3251,5,176); 
        insert into oehr_inventories values(3252,5,176); 
        insert into oehr_inventories values(3253,5,176); 
        insert into oehr_inventories values(3255,5,176); 
        insert into oehr_inventories values(3256,5,177); 
        insert into oehr_inventories values(3257,5,177); 
        insert into oehr_inventories values(3258,5,177); 
        insert into oehr_inventories values(3260,5,177); 
        insert into oehr_inventories values(3300,5,237); 
        insert into oehr_inventories values(3301,5,237); 
        insert into oehr_inventories values(3337,5,199); 
        insert into oehr_inventories values(3361,5,193); 
        insert into oehr_inventories values(3362,5,194); 
        insert into oehr_inventories values(3391,5,203); 
        insert into oehr_inventories values(3501,5,220); 
        insert into oehr_inventories values(3502,5,216); 
        insert into oehr_inventories values(3503,5,216); 
        insert into oehr_inventories values(1729,6,58); 
        insert into oehr_inventories values(1733,6,29); 
        insert into oehr_inventories values(1734,6,30); 
        insert into oehr_inventories values(1737,6,30); 
        insert into oehr_inventories values(1738,6,30); 
        insert into oehr_inventories values(1739,6,30); 
        insert into oehr_inventories values(1740,6,30); 
        insert into oehr_inventories values(1742,6,31); 
        insert into oehr_inventories values(1745,6,31); 
        insert into oehr_inventories values(1748,6,32); 
        insert into oehr_inventories values(1749,6,32); 
        insert into oehr_inventories values(1750,6,32); 
        insert into oehr_inventories values(1755,6,33); 
        insert into oehr_inventories values(1763,6,34); 
        insert into oehr_inventories values(1768,6,35); 
        insert into oehr_inventories values(1769,6,35); 
        insert into oehr_inventories values(1770,6,35); 
        insert into oehr_inventories values(1772,6,36); 
        insert into oehr_inventories values(1774,6,62); 
        insert into oehr_inventories values(1775,6,62); 
        insert into oehr_inventories values(1778,6,62); 
        insert into oehr_inventories values(1779,6,62); 
        insert into oehr_inventories values(1780,6,63); 
        insert into oehr_inventories values(1781,6,37); 
        insert into oehr_inventories values(1787,6,38); 
        insert into oehr_inventories values(1788,6,38); 
        insert into oehr_inventories values(1791,6,39); 
        insert into oehr_inventories values(1792,6,39); 
        insert into oehr_inventories values(1794,6,65); 
        insert into oehr_inventories values(1797,6,39); 
        insert into oehr_inventories values(1799,6,66); 
        insert into oehr_inventories values(1801,6,66); 
        insert into oehr_inventories values(1803,6,66); 
        insert into oehr_inventories values(1804,6,66); 
        insert into oehr_inventories values(1805,6,66); 
        insert into oehr_inventories values(1806,6,67); 
        insert into oehr_inventories values(1808,6,67); 
      end;~';
   insert into wwv_sample_dmls (wwv_sample_dataset_id, language_cd, dml_name, install_seq, dml) 
   values (  3, 'en', 'Insert Into inventories (Part 1)', 70, l_clob); 

   l_clob :=q'~begin             
        insert into oehr_inventories values(1820,6,69); 
        insert into oehr_inventories values(1822,6,69); 
        insert into oehr_inventories values(1825,6,70); 
        insert into oehr_inventories values(1912,6,29); 
        insert into oehr_inventories values(1940,6,33); 
        insert into oehr_inventories values(2005,6,84); 
        insert into oehr_inventories values(2058,6,66); 
        insert into oehr_inventories values(2093,6,58); 
        insert into oehr_inventories values(2144,6,66); 
        insert into oehr_inventories values(2243,6,30); 
        insert into oehr_inventories values(2245,6,30); 
        insert into oehr_inventories values(2255,6,34); 
        insert into oehr_inventories values(2257,6,35); 
        insert into oehr_inventories values(2259,6,35); 
        insert into oehr_inventories values(2260,6,35); 
        insert into oehr_inventories values(2261,6,35); 
        insert into oehr_inventories values(2262,6,35); 
        insert into oehr_inventories values(2264,6,63); 
        insert into oehr_inventories values(2266,6,63); 
        insert into oehr_inventories values(2270,6,64); 
        insert into oehr_inventories values(2274,6,65); 
        insert into oehr_inventories values(2276,6,65); 
        insert into oehr_inventories values(2278,6,65); 
        insert into oehr_inventories values(2302,6,69); 
        insert into oehr_inventories values(2316,6,71); 
        insert into oehr_inventories values(2319,6,44); 
        insert into oehr_inventories values(2322,6,45); 
        insert into oehr_inventories values(2323,6,45); 
        insert into oehr_inventories values(2326,6,58); 
        insert into oehr_inventories values(2335,6,71); 
        insert into oehr_inventories values(2336,6,60); 
        insert into oehr_inventories values(2337,6,60); 
        insert into oehr_inventories values(2340,6,72); 
        insert into oehr_inventories values(2350,6,73); 
        insert into oehr_inventories values(2351,6,74); 
        insert into oehr_inventories values(2359,6,51); 
        insert into oehr_inventories values(2365,6,76); 
        insert into oehr_inventories values(2370,6,53); 
        insert into oehr_inventories values(2371,6,71); 
        insert into oehr_inventories values(2373,6,53); 
        insert into oehr_inventories values(2374,6,53); 
        insert into oehr_inventories values(2375,6,53); 
        insert into oehr_inventories values(2377,6,54); 
        insert into oehr_inventories values(2378,6,54); 
        insert into oehr_inventories values(2380,6,54); 
        insert into oehr_inventories values(2387,6,55); 
        insert into oehr_inventories values(2394,6,56); 
        insert into oehr_inventories values(2395,6,56); 
        insert into oehr_inventories values(2396,6,57); 
        insert into oehr_inventories values(2402,6,58); 
        insert into oehr_inventories values(2403,6,58); 
        insert into oehr_inventories values(2404,6,58); 
        insert into oehr_inventories values(2406,6,58); 
        insert into oehr_inventories values(2408,6,59); 
        insert into oehr_inventories values(2409,6,59); 
        insert into oehr_inventories values(2410,6,59); 
        insert into oehr_inventories values(2411,6,59); 
        insert into oehr_inventories values(2414,6,59); 
        insert into oehr_inventories values(2415,6,60); 
        insert into oehr_inventories values(2416,6,78); 
        insert into oehr_inventories values(2417,6,29); 
        insert into oehr_inventories values(2418,6,60); 
        insert into oehr_inventories values(2419,6,60); 
        insert into oehr_inventories values(2422,6,29); 
        insert into oehr_inventories values(2423,6,29); 
        insert into oehr_inventories values(2424,6,61); 
        insert into oehr_inventories values(2430,6,65); 
        insert into oehr_inventories values(2439,6,66); 
        insert into oehr_inventories values(2449,6,34); 
        insert into oehr_inventories values(2452,6,34); 
        insert into oehr_inventories values(2453,6,68); 
        insert into oehr_inventories values(2457,6,69); 
        insert into oehr_inventories values(2462,6,36); 
        insert into oehr_inventories values(2464,6,36); 
        insert into oehr_inventories values(2467,6,37); 
        insert into oehr_inventories values(2468,6,37); 
        insert into oehr_inventories values(2470,6,37); 
        insert into oehr_inventories values(2471,6,37); 
        insert into oehr_inventories values(2492,6,41); 
        insert into oehr_inventories values(2493,6,41); 
        insert into oehr_inventories values(2494,6,41); 
        insert into oehr_inventories values(2537,6,42); 
        insert into oehr_inventories values(2596,6,51); 
        insert into oehr_inventories values(2631,6,57); 
        insert into oehr_inventories values(2638,6,72); 
        insert into oehr_inventories values(2722,6,71); 
        insert into oehr_inventories values(2752,6,90); 
        insert into oehr_inventories values(2779,6,80); 
        insert into oehr_inventories values(2783,6,81); 
        insert into oehr_inventories values(2810,6,85); 
        insert into oehr_inventories values(2870,6,94); 
        insert into oehr_inventories values(2878,6,110); 
        insert into oehr_inventories values(2879,6,110); 
        insert into oehr_inventories values(3000,6,163); 
        insert into oehr_inventories values(3003,6,164); 
        insert into oehr_inventories values(3004,6,164); 
        insert into oehr_inventories values(3054,6,172); 
        insert into oehr_inventories values(3057,6,172); 
        insert into oehr_inventories values(3060,6,173); 
        insert into oehr_inventories values(3061,6,173); 
        insert into oehr_inventories values(3065,6,174); 
        insert into oehr_inventories values(3071,6,175); 
        insert into oehr_inventories values(3072,6,175); 
        insert into oehr_inventories values(3077,6,176); 
        insert into oehr_inventories values(3082,6,176); 
        insert into oehr_inventories values(3083,6,177); 
        insert into oehr_inventories values(3086,6,177); 
        insert into oehr_inventories values(3088,6,177); 
        insert into oehr_inventories values(3090,6,178); 
        insert into oehr_inventories values(3091,6,178); 
        insert into oehr_inventories values(3099,6,145); 
        insert into oehr_inventories values(3108,6,146); 
        insert into oehr_inventories values(3110,6,147); 
        insert into oehr_inventories values(3112,6,147); 
        insert into oehr_inventories values(3117,6,148); 
        insert into oehr_inventories values(3124,6,149); 
        insert into oehr_inventories values(3127,6,149); 
        insert into oehr_inventories values(3129,6,150); 
        insert into oehr_inventories values(3134,6,185); 
        insert into oehr_inventories values(3139,6,185); 
        insert into oehr_inventories values(3140,6,186); 
        insert into oehr_inventories values(3143,6,186); 
        insert into oehr_inventories values(3165,6,141); 
        insert into oehr_inventories values(3167,6,141); 
        insert into oehr_inventories values(3170,6,149); 
        insert into oehr_inventories values(3171,6,149); 
        insert into oehr_inventories values(3172,6,150); 
        insert into oehr_inventories values(3173,6,150); 
        insert into oehr_inventories values(3175,6,150); 
        insert into oehr_inventories values(3176,6,150); 
        insert into oehr_inventories values(3177,6,150); 
        insert into oehr_inventories values(3178,6,151); 
        insert into oehr_inventories values(3179,6,151); 
        insert into oehr_inventories values(3182,6,151); 
        insert into oehr_inventories values(3183,6,151); 
        insert into oehr_inventories values(3189,6,145); 
        insert into oehr_inventories values(3191,6,145); 
        insert into oehr_inventories values(3193,6,145); 
        insert into oehr_inventories values(3204,6,161); 
        insert into oehr_inventories values(3209,6,148); 
        insert into oehr_inventories values(3225,6,150); 
        insert into oehr_inventories values(3246,6,161); 
        insert into oehr_inventories values(3247,6,162); 
        insert into oehr_inventories values(3248,6,162); 
        insert into oehr_inventories values(3250,6,162); 
        insert into oehr_inventories values(3251,6,162); 
        insert into oehr_inventories values(3252,6,162); 
        insert into oehr_inventories values(3253,6,163); 
        insert into oehr_inventories values(3255,6,163); 
        insert into oehr_inventories values(3256,6,163); 
        insert into oehr_inventories values(3257,6,163); 
        insert into oehr_inventories values(3258,6,163); 
        insert into oehr_inventories values(3260,6,164); 
        insert into oehr_inventories values(3300,6,214); 
        insert into oehr_inventories values(3301,6,214); 
        insert into oehr_inventories values(3331,6,221); 
        insert into oehr_inventories values(3334,6,222); 
        insert into oehr_inventories values(3337,6,184); 
        insert into oehr_inventories values(3350,6,184); 
        insert into oehr_inventories values(3354,6,225); 
        insert into oehr_inventories values(3355,6,225); 
        insert into oehr_inventories values(3359,6,226); 
        insert into oehr_inventories values(3361,6,180); 
        insert into oehr_inventories values(3362,6,180); 
        insert into oehr_inventories values(3391,6,191); 
        insert into oehr_inventories values(3400,6,232); 
        insert into oehr_inventories values(3501,6,320); 
        insert into oehr_inventories values(3502,6,202); 
        insert into oehr_inventories values(3503,6,203); 
        insert into oehr_inventories values(3511,6,212); 
        insert into oehr_inventories values(3515,6,213); 
        insert into oehr_inventories values(1729,7,46); 
        insert into oehr_inventories values(1733,7,63); 
        insert into oehr_inventories values(1734,7,63); 
        insert into oehr_inventories values(1737,7,63); 
        insert into oehr_inventories values(1738,7,63); 
        insert into oehr_inventories values(1745,7,65); 
        insert into oehr_inventories values(1748,7,65); 
        insert into oehr_inventories values(1774,7,50); 
        insert into oehr_inventories values(1775,7,50); 
        insert into oehr_inventories values(1778,7,50); 
        insert into oehr_inventories values(1779,7,51); 
        insert into oehr_inventories values(1780,7,51); 
        insert into oehr_inventories values(1794,7,53); 
        insert into oehr_inventories values(1799,7,54); 
        insert into oehr_inventories values(1801,7,54); 
        insert into oehr_inventories values(1803,7,55); 
        insert into oehr_inventories values(1804,7,55); 
        insert into oehr_inventories values(1805,7,55); 
        insert into oehr_inventories values(1806,7,55); 
        insert into oehr_inventories values(1808,7,55); 
        insert into oehr_inventories values(1820,7,57); 
        insert into oehr_inventories values(1822,7,58); 
        insert into oehr_inventories values(1825,7,58); 
        insert into oehr_inventories values(1912,7,18); 
        insert into oehr_inventories values(1940,7,22); 
        insert into oehr_inventories values(2005,7,58); 
        insert into oehr_inventories values(2278,7,53); 
        insert into oehr_inventories values(2316,7,59); 
        insert into oehr_inventories values(2319,7,27); 
        insert into oehr_inventories values(2322,7,27); 
        insert into oehr_inventories values(2323,7,27); 
        insert into oehr_inventories values(2326,7,46); 
        insert into oehr_inventories values(2335,7,57); 
        insert into oehr_inventories values(2340,7,58); 
        insert into oehr_inventories values(2350,7,60); 
        insert into oehr_inventories values(2351,7,60); 
        insert into oehr_inventories values(2365,7,62); 
        insert into oehr_inventories values(2370,7,35); 
        insert into oehr_inventories values(2371,7,58); 
        insert into oehr_inventories values(2373,7,35); 
        insert into oehr_inventories values(2377,7,36); 
        insert into oehr_inventories values(2380,7,36); 
        insert into oehr_inventories values(2387,7,37); 
        insert into oehr_inventories values(2408,7,41); 
        insert into oehr_inventories values(2416,7,66); 
        insert into oehr_inventories values(2417,7,66); 
        insert into oehr_inventories values(2418,7,45); 
        insert into oehr_inventories values(2419,7,45); 
        insert into oehr_inventories values(2422,7,17); 
        insert into oehr_inventories values(2423,7,17); 
        insert into oehr_inventories values(2449,7,21); 
        insert into oehr_inventories values(2452,7,21); 
        insert into oehr_inventories values(2457,7,51); 
        insert into oehr_inventories values(2462,7,23); 
        insert into oehr_inventories values(2464,7,23); 
        insert into oehr_inventories values(2467,7,24); 
        insert into oehr_inventories values(2468,7,24); 
        insert into oehr_inventories values(2470,7,24); 
        insert into oehr_inventories values(2471,7,24); 
        insert into oehr_inventories values(2492,7,28); 
        insert into oehr_inventories values(2493,7,28); 
        insert into oehr_inventories values(2494,7,28); 
        insert into oehr_inventories values(2596,7,39); 
        insert into oehr_inventories values(2631,7,45); 
        insert into oehr_inventories values(2638,7,60); 
        insert into oehr_inventories values(2722,7,59); 
        insert into oehr_inventories values(2779,7,68); 
        insert into oehr_inventories values(2878,7,98); 
        insert into oehr_inventories values(2879,7,98); 
        insert into oehr_inventories values(3000,7,143); 
        insert into oehr_inventories values(3003,7,143); 
        insert into oehr_inventories values(3004,7,144); 
        insert into oehr_inventories values(3099,7,133); 
        insert into oehr_inventories values(3124,7,137); 
        insert into oehr_inventories values(3134,7,167); 
        insert into oehr_inventories values(3139,7,168); 
        insert into oehr_inventories values(3140,7,168); 
        insert into oehr_inventories values(3143,7,168); 
        insert into oehr_inventories values(3170,7,136); 
        insert into oehr_inventories values(3171,7,136); 
        insert into oehr_inventories values(3172,7,136); 
        insert into oehr_inventories values(3173,7,137); 
        insert into oehr_inventories values(3175,7,137); 
        insert into oehr_inventories values(3176,7,137); 
        insert into oehr_inventories values(3177,7,137); 
        insert into oehr_inventories values(3189,7,133); 
        insert into oehr_inventories values(3191,7,133); 
        insert into oehr_inventories values(3193,7,133); 
        insert into oehr_inventories values(3204,7,149); 
        insert into oehr_inventories values(3246,7,148); 
        insert into oehr_inventories values(3247,7,148); 
        insert into oehr_inventories values(3248,7,149); 
        insert into oehr_inventories values(3250,7,149); 
        insert into oehr_inventories values(3251,7,149); 
        insert into oehr_inventories values(3252,7,149); 
        insert into oehr_inventories values(3253,7,149); 
        insert into oehr_inventories values(3257,7,150); 
        insert into oehr_inventories values(3258,7,150); 
        insert into oehr_inventories values(3300,7,196); 
        insert into oehr_inventories values(3301,7,196); 
        insert into oehr_inventories values(3337,7,170); 
        insert into oehr_inventories values(3362,7,167); 
        insert into oehr_inventories values(3391,7,179); 
        insert into oehr_inventories values(3501,7,294); 
        insert into oehr_inventories values(3502,7,189); 
        insert into oehr_inventories values(3503,7,189); 
        insert into oehr_inventories values(1729,8,34); 
        insert into oehr_inventories values(1733,8,49); 
        insert into oehr_inventories values(1734,8,49); 
        insert into oehr_inventories values(1737,8,49); 
        insert into oehr_inventories values(1738,8,50); 
        insert into oehr_inventories values(1739,8,50); 
        insert into oehr_inventories values(1740,8,50); 
        insert into oehr_inventories values(1742,8,50); 
        insert into oehr_inventories values(1745,8,51); 
        insert into oehr_inventories values(1748,8,51); 
        insert into oehr_inventories values(1749,8,51); 
        insert into oehr_inventories values(1750,8,51); 
        insert into oehr_inventories values(1755,8,52); 
        insert into oehr_inventories values(1763,8,54); 
        insert into oehr_inventories values(1768,8,54); 
        insert into oehr_inventories values(1769,8,54); 
        insert into oehr_inventories values(1770,8,5); 
        insert into oehr_inventories values(1772,8,5); 
        insert into oehr_inventories values(1774,8,38); 
        insert into oehr_inventories values(1775,8,39); 
        insert into oehr_inventories values(1778,8,39); 
        insert into oehr_inventories values(1779,8,39); 
        insert into oehr_inventories values(1780,8,39); 
        insert into oehr_inventories values(1781,8,6); 
        insert into oehr_inventories values(1787,8,7); 
        insert into oehr_inventories values(1788,8,7); 
        insert into oehr_inventories values(1791,8,8); 
        insert into oehr_inventories values(1792,8,8); 
        insert into oehr_inventories values(1794,8,42); 
        insert into oehr_inventories values(1797,8,9); 
        insert into oehr_inventories values(1799,8,42); 
        insert into oehr_inventories values(1801,8,43); 
        insert into oehr_inventories values(1803,8,43); 
        insert into oehr_inventories values(1804,8,43); 
        insert into oehr_inventories values(1805,8,43); 
        insert into oehr_inventories values(1806,8,44); 
        insert into oehr_inventories values(1808,8,44); 
        insert into oehr_inventories values(1820,8,46); 
        insert into oehr_inventories values(1822,8,46); 
        insert into oehr_inventories values(1825,8,47); 
        insert into oehr_inventories values(1912,8,7); 
        insert into oehr_inventories values(1940,8,11); 
        insert into oehr_inventories values(2005,8,32); 
        insert into oehr_inventories values(2058,8,44); 
        insert into oehr_inventories values(2243,8,47); 
        insert into oehr_inventories values(2245,8,47); 
        insert into oehr_inventories values(2255,8,49); 
        insert into oehr_inventories values(2257,8,49); 
        insert into oehr_inventories values(2259,8,50); 
        insert into oehr_inventories values(2260,8,50); 
        insert into oehr_inventories values(2261,8,50); 
        insert into oehr_inventories values(2262,8,50); 
        insert into oehr_inventories values(2264,8,39); 
        insert into oehr_inventories values(2266,8,39); 
        insert into oehr_inventories values(2270,8,40); 
        insert into oehr_inventories values(2274,8,41); 
        insert into oehr_inventories values(2276,8,41); 
        insert into oehr_inventories values(2278,8,41); 
        insert into oehr_inventories values(2302,8,45); 
        insert into oehr_inventories values(2316,8,47); 
        insert into oehr_inventories values(2319,8,12); 
        insert into oehr_inventories values(2322,8,12); 
        insert into oehr_inventories values(2323,8,13); 
        insert into oehr_inventories values(2326,8,34); 
        insert into oehr_inventories values(2335,8,44); 
        insert into oehr_inventories values(2340,8,45); 
        insert into oehr_inventories values(2350,8,47); 
        insert into oehr_inventories values(2351,8,47); 
        insert into oehr_inventories values(2359,8,18); 
        insert into oehr_inventories values(2365,8,49); 
        insert into oehr_inventories values(2370,8,20); 
        insert into oehr_inventories values(2371,8,46); 
        insert into oehr_inventories values(2373,8,20); 
        insert into oehr_inventories values(2374,8,21); 
        insert into oehr_inventories values(2375,8,21); 
        insert into oehr_inventories values(2377,8,21); 
        insert into oehr_inventories values(2378,8,21); 
        insert into oehr_inventories values(2380,8,22); 
        insert into oehr_inventories values(2387,8,23); 
        insert into oehr_inventories values(2394,8,24); 
        insert into oehr_inventories values(2395,8,24); 
        insert into oehr_inventories values(2396,8,24); 
        insert into oehr_inventories values(2402,8,25); 
        insert into oehr_inventories values(2403,8,25); 
        insert into oehr_inventories values(2404,8,25); 
        insert into oehr_inventories values(2406,8,26); 
        insert into oehr_inventories values(2408,8,26); 
        insert into oehr_inventories values(2409,8,26); 
        insert into oehr_inventories values(2410,8,26); 
        insert into oehr_inventories values(2411,8,26); 
        insert into oehr_inventories values(2414,8,27); 
        insert into oehr_inventories values(2415,8,27); 
        insert into oehr_inventories values(2416,8,53); 
        insert into oehr_inventories values(2417,8,53); 
        insert into oehr_inventories values(2418,8,28); 
        insert into oehr_inventories values(2419,8,28); 
        insert into oehr_inventories values(2422,8,54); 
        insert into oehr_inventories values(2423,8,54); 
        insert into oehr_inventories values(2424,8,28); 
        insert into oehr_inventories values(2430,8,29); 
        insert into oehr_inventories values(2439,8,31); 
        insert into oehr_inventories values(2449,8,8); 
        insert into oehr_inventories values(2452,8,9); 
        insert into oehr_inventories values(2453,8,33); 
        insert into oehr_inventories values(2457,8,34); 
        insert into oehr_inventories values(2462,8,10); 
        insert into oehr_inventories values(2464,8,11); 
        insert into oehr_inventories values(2467,8,11); 
        insert into oehr_inventories values(2468,8,11); 
        insert into oehr_inventories values(2470,8,12); 
        insert into oehr_inventories values(2471,8,12); 
        insert into oehr_inventories values(2492,8,15); 
        insert into oehr_inventories values(2493,8,15); 
        insert into oehr_inventories values(2494,8,15); 
        insert into oehr_inventories values(2596,8,27); 
        insert into oehr_inventories values(2631,8,33); 
        insert into oehr_inventories values(2638,8,48); 
        insert into oehr_inventories values(2722,8,47); 
        insert into oehr_inventories values(2752,8,66); 
        insert into oehr_inventories values(2779,8,56); 
        insert into oehr_inventories values(2878,8,86); 
        insert into oehr_inventories values(2879,8,86); 
        insert into oehr_inventories values(3000,8,128); 
        insert into oehr_inventories values(3003,8,128); 
        insert into oehr_inventories values(3004,8,129); 
        insert into oehr_inventories values(3054,8,137); 
        insert into oehr_inventories values(3057,8,137); 
        insert into oehr_inventories values(3060,8,137); 
        insert into oehr_inventories values(3061,8,138); 
        insert into oehr_inventories values(3065,8,138); 
        insert into oehr_inventories values(3071,8,139); 
        insert into oehr_inventories values(3072,8,139); 
        insert into oehr_inventories values(3077,8,140); 
        insert into oehr_inventories values(3082,8,141); 
        insert into oehr_inventories values(3083,8,141); 
        insert into oehr_inventories values(3086,8,142); 
        insert into oehr_inventories values(3088,8,142); 
        insert into oehr_inventories values(3090,8,142); 
        insert into oehr_inventories values(3091,8,142); 
        insert into oehr_inventories values(3099,8,121); 
        insert into oehr_inventories values(3108,8,122); 
        insert into oehr_inventories values(3110,8,123); 
        insert into oehr_inventories values(3112,8,123); 
        insert into oehr_inventories values(3117,8,124); 
        insert into oehr_inventories values(3124,8,125); 
        insert into oehr_inventories values(3127,8,125); 
        insert into oehr_inventories values(3129,8,126); 
        insert into oehr_inventories values(3134,8,149); 
        insert into oehr_inventories values(3139,8,150); 
        insert into oehr_inventories values(3140,8,150); 
        insert into oehr_inventories values(3143,8,151); 
        insert into oehr_inventories values(3170,8,123); 
        insert into oehr_inventories values(3171,8,124); 
        insert into oehr_inventories values(3172,8,124); 
        insert into oehr_inventories values(3173,8,124); 
        insert into oehr_inventories values(3175,8,124); 
        insert into oehr_inventories values(3176,8,124); 
        insert into oehr_inventories values(3177,8,125); 
        insert into oehr_inventories values(3189,8,121); 
        insert into oehr_inventories values(3191,8,121); 
        insert into oehr_inventories values(3193,8,121); 
        insert into oehr_inventories values(3204,8,137); 
        insert into oehr_inventories values(3246,8,136); 
        insert into oehr_inventories values(3247,8,136); 
        insert into oehr_inventories values(3248,8,136); 
        insert into oehr_inventories values(3250,8,136); 
        insert into oehr_inventories values(3251,8,136); 
        insert into oehr_inventories values(3252,8,137); 
        insert into oehr_inventories values(3253,8,137); 
        insert into oehr_inventories values(3257,8,137); 
        insert into oehr_inventories values(3258,8,137); 
        insert into oehr_inventories values(3300,8,178); 
        insert into oehr_inventories values(3301,8,178); 
        insert into oehr_inventories values(3331,8,183); 
        insert into oehr_inventories values(3334,8,184); 
        insert into oehr_inventories values(3337,8,156); 
        insert into oehr_inventories values(3350,8,160); 
        insert into oehr_inventories values(3354,8,187); 
        insert into oehr_inventories values(3355,8,187); 
        insert into oehr_inventories values(3359,8,188); 
        insert into oehr_inventories values(3362,8,154); 
        insert into oehr_inventories values(3391,8,167); 
        insert into oehr_inventories values(3400,8,194); 
        insert into oehr_inventories values(3501,8,268); 
        insert into oehr_inventories values(3502,8,176); 
        insert into oehr_inventories values(3503,8,177); 
        insert into oehr_inventories values(1729,9,23); 
        insert into oehr_inventories values(1733,9,35); 
        insert into oehr_inventories values(1734,9,35); 
        insert into oehr_inventories values(1737,9,36); 
        insert into oehr_inventories values(1738,9,36); 
        insert into oehr_inventories values(1739,9,36); 
        insert into oehr_inventories values(1740,9,36); 
        insert into oehr_inventories values(1742,9,36); 
        insert into oehr_inventories values(1745,9,37); 
        insert into oehr_inventories values(1748,9,37); 
        insert into oehr_inventories values(1749,9,37); 
        insert into oehr_inventories values(1750,9,38); 
        insert into oehr_inventories values(1755,9,41); 
        insert into oehr_inventories values(1763,9,3); 
        insert into oehr_inventories values(1768,9,3); 
        insert into oehr_inventories values(1769,9,3); 
        insert into oehr_inventories values(1770,9,4); 
        insert into oehr_inventories values(1772,9,4); 
        insert into oehr_inventories values(1781,9,5); 
        insert into oehr_inventories values(1787,9,6); 
        insert into oehr_inventories values(1788,9,6); 
        insert into oehr_inventories values(1791,9,7); 
        insert into oehr_inventories values(1792,9,7); 
        insert into oehr_inventories values(1797,9,8); 
        insert into oehr_inventories values(1912,9,6); 
        insert into oehr_inventories values(1940,9,0); 
        insert into oehr_inventories values(2058,9,33); 
        insert into oehr_inventories values(2243,9,32); 
        insert into oehr_inventories values(2245,9,33); 
        insert into oehr_inventories values(2255,9,34); 
        insert into oehr_inventories values(2257,9,34); 
        insert into oehr_inventories values(2259,9,35); 
        insert into oehr_inventories values(2260,9,35); 
        insert into oehr_inventories values(2261,9,35); 
        insert into oehr_inventories values(2262,9,35); 
        insert into oehr_inventories values(2264,9,27); 
        insert into oehr_inventories values(2266,9,27); 
        insert into oehr_inventories values(2270,9,28); 
        insert into oehr_inventories values(2274,9,29); 
        insert into oehr_inventories values(2276,9,29); 
        insert into oehr_inventories values(2278,9,29); 
        insert into oehr_inventories values(2302,9,33); 
        insert into oehr_inventories values(2316,9,35); 
        insert into oehr_inventories values(2319,9,7); 
        insert into oehr_inventories values(2322,9,8); 
        insert into oehr_inventories values(2323,9,8); 
        insert into oehr_inventories values(2326,9,22); 
        insert into oehr_inventories values(2340,9,32); 
        insert into oehr_inventories values(2359,9,3); 
        insert into oehr_inventories values(2365,9,36); 
        insert into oehr_inventories values(2370,9,5); 
        insert into oehr_inventories values(2373,9,6); 
        insert into oehr_inventories values(2374,9,6); 
        insert into oehr_inventories values(2375,9,6); 
        insert into oehr_inventories values(2377,9,6); 
        insert into oehr_inventories values(2378,9,6); 
        insert into oehr_inventories values(2380,9,7); 
        insert into oehr_inventories values(2387,9,8); 
        insert into oehr_inventories values(2394,9,9); 
        insert into oehr_inventories values(2395,9,9); 
        insert into oehr_inventories values(2396,9,9); 
        insert into oehr_inventories values(2402,9,10); 
        insert into oehr_inventories values(2403,9,10); 
        insert into oehr_inventories values(2404,9,10); 
      end;~';
   insert into wwv_sample_dmls (wwv_sample_dataset_id, language_cd, dml_name, install_seq, dml) 
   values (  3, 'en', 'Insert Into inventories (Part 2)', 71, l_clob); 

   l_clob :=q'~begin             
        insert into oehr_inventories values(2406,9,11); 
        insert into oehr_inventories values(2408,9,11); 
        insert into oehr_inventories values(2409,9,11); 
        insert into oehr_inventories values(2410,9,11); 
        insert into oehr_inventories values(2411,9,12); 
        insert into oehr_inventories values(2414,9,12); 
        insert into oehr_inventories values(2415,9,12); 
        insert into oehr_inventories values(2418,9,13); 
        insert into oehr_inventories values(2419,9,13); 
        insert into oehr_inventories values(2424,9,14); 
        insert into oehr_inventories values(2430,9,15); 
        insert into oehr_inventories values(2439,9,16); 
        insert into oehr_inventories values(2453,9,18); 
        insert into oehr_inventories values(2457,9,19); 
        insert into oehr_inventories values(2596,9,15); 
        insert into oehr_inventories values(2631,9,21); 
        insert into oehr_inventories values(2638,9,36); 
        insert into oehr_inventories values(2722,9,35); 
        insert into oehr_inventories values(2752,9,54); 
        insert into oehr_inventories values(2878,9,74); 
        insert into oehr_inventories values(2879,9,74); 
        insert into oehr_inventories values(3000,9,110); 
        insert into oehr_inventories values(3003,9,111); 
        insert into oehr_inventories values(3004,9,111); 
        insert into oehr_inventories values(3054,9,119); 
        insert into oehr_inventories values(3057,9,119); 
        insert into oehr_inventories values(3060,9,120); 
        insert into oehr_inventories values(3061,9,120); 
        insert into oehr_inventories values(3065,9,121); 
        insert into oehr_inventories values(3071,9,122); 
        insert into oehr_inventories values(3072,9,122); 
        insert into oehr_inventories values(3077,9,122); 
        insert into oehr_inventories values(3082,9,123); 
        insert into oehr_inventories values(3083,9,123); 
        insert into oehr_inventories values(3086,9,124); 
        insert into oehr_inventories values(3088,9,124); 
        insert into oehr_inventories values(3090,9,125); 
        insert into oehr_inventories values(3091,9,125); 
        insert into oehr_inventories values(3099,9,109); 
        insert into oehr_inventories values(3108,9,110); 
        insert into oehr_inventories values(3110,9,111); 
        insert into oehr_inventories values(3112,9,111); 
        insert into oehr_inventories values(3117,9,112); 
        insert into oehr_inventories values(3124,9,113); 
        insert into oehr_inventories values(3127,9,113); 
        insert into oehr_inventories values(3129,9,114); 
        insert into oehr_inventories values(3134,9,134); 
        insert into oehr_inventories values(3139,9,135); 
        insert into oehr_inventories values(3140,9,135); 
        insert into oehr_inventories values(3143,9,136); 
        insert into oehr_inventories values(3189,9,109); 
        insert into oehr_inventories values(3191,9,109); 
        insert into oehr_inventories values(3193,9,109); 
        insert into oehr_inventories values(3204,9,125); 
        insert into oehr_inventories values(3300,9,161); 
        insert into oehr_inventories values(3301,9,161); 
        insert into oehr_inventories values(3331,9,165); 
        insert into oehr_inventories values(3334,9,166); 
        insert into oehr_inventories values(3350,9,148); 
        insert into oehr_inventories values(3354,9,169); 
        insert into oehr_inventories values(3355,9,169); 
        insert into oehr_inventories values(3359,9,170); 
        insert into oehr_inventories values(3391,9,155); 
        insert into oehr_inventories values(3400,9,179); 
      end;~';
   insert into wwv_sample_dmls (wwv_sample_dataset_id, language_cd, dml_name, install_seq, dml) 
   values (  3, 'en', 'Insert Into inventories (Part 3)', 72, l_clob); 


   l_clob :=q'~begin             
        insert into oehr_promotions (promo_id, promo_name)
          values (1, 'everyday low price');
        
        insert into oehr_promotions (promo_id, promo_name)
          values (2, 'blowout sale');
        
        update oehr_orders
        set order_date = order_date + trunc(SYSDATE - to_date('20000802', 'YYYYMMDD'));
        
        update oehr_employees 
        set hire_date = hire_date + trunc(SYSDATE - to_date('20000802', 'YYYYMMDD'));
        
        update oehr_job_history 
        set start_date = start_date + trunc(SYSDATE - to_date('20000802', 'YYYYMMDD'))
        ,   end_date = end_date + trunc(SYSDATE - to_date('20000802', 'YYYYMMDD'));
      end;~';
   insert into wwv_sample_dmls (wwv_sample_dataset_id, language_cd, dml_name, install_seq, dml) 
   values (  3, 'en', 'Update orders', 80, l_clob); 

    commit;
end;
/
