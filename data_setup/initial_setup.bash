# install postgres
sudo apt-get install postgresql -y

sudo -u postgres -i

# creating Data folder and downloading data
mkdir Data && cd Data
echo "Before downloading the data please makesure you have access to the dataset"
read -r -p 'Please enter user username for PhysioNet>>> ' username
wget --user $username --ask-password -A csv.gz -m -p -E -k -K -np -nd https://physionet.org/works/MIMICIIIClinicalDatabase/files/

# unzipping data
gunzip ./*.gz

cd ../

# build and make code download
git clone https://github.com/MIT-LCP/mimic-code.git
cd mimic-code/buildmimic/postgres/
make create-user mimic datadir="../../Data"

# run everytime you start postgres
\c mimic;
CREATE SCHEMA mimiciii;
set search_path to mimiciii;

# grant data permissions
psql 'dbname=mimic user=postgres options=--search_path=mimiciii'
grant select on all tables in schema mimiciii to postgres;
grant usage on schema mimiciii to postgres;
grant connect on database mimic to postgres;
alter user postgres nosuperuser;

# trying to count number of patients
select count(subject_id)
from mimiciii.patients;

# or this way
select count(subject_id)
from patients;

echo "Postgres and ECG data setup successful!!"

