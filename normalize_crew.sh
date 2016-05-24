#!/usr/bin/env node

var input = '';

process.stdin.on('readable', () => {
  var chunk = process.stdin.read();
  if (chunk !== null) {
    input += chunk;
  }
});

process.stdin.on('end', () => {
  var parsed = JSON.parse(input);
  var output = parsed.map(normalizeCrew);
  process.stdout.write(JSON.stringify( { docs: output } ));
});

var normalizeCrew = (crew) => {
  var toReturn = {};

  toReturn.type = 'type/crew/v1'

  toReturn.firstName = crew.first_name;
  toReturn.lastName = crew.last_name;
  toReturn.contact = {};

  if(crew.mobile_phone) {
    toReturn.contact.phone = [];
    toReturn.contact.phone.push({ kind: 'mobile', phoneNumber: crew.mobile_phone });
  }

  if(crew.landline) {
    toReturn.contact.phone = toReturn.contact.phone || [];
    toReturn.contact.phone.push({ kind: 'landline', phoneNumber: crew.landline });
  }

  if(crew.email) {
    toReturn.contact.email = [crew.email];
  }

  if(crew.street && crew.city) {
    toReturn.address = {};
    if(!isNaN(Number(crew.street.split(' ').slice(-1)))) {
      toReturn.address.number = Number(crew.street.split(' ').slice(-1));
      toReturn.address.street = crew.street.split(' ').slice(0, -1).join(' ');
    }

    if(!isNaN(Number(crew.city.split(' ')[0]))) {
      toReturn.address.zipCode = Number(crew.city.split(' ')[0]);
      toReturn.address.city = crew.city.split(' ').slice(1).join(' ');
    } else toReturn.address.city = crew.city;
    
  }

  if(crew.birth_date) toReturn.birthDate = crew.birth_date;
  if(crew.bank_account) toReturn.bankAccount = crew.bank_account;
  if(crew.year_started_volunteering) toReturn.yearStarted = crew.year_started_volunteering;

  return toReturn;
};

