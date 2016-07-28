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
  toReturn.doc = {};

  toReturn.kind = 'type/crew/v1'

  toReturn.doc.firstName = crew.first_name;
  toReturn.doc.lastName = crew.last_name;
  toReturn.doc.contact = {};

  if(crew.mobile_phone) {
    toReturn.doc.contact.phone = [];
    toReturn.doc.contact.phone.push({ kind: 'mobile', phoneNumber: crew.mobile_phone });
  }

  if(crew.landline) {
    toReturn.doc.contact.phone = toReturn.doc.contact.phone || [];
    toReturn.doc.contact.phone.push({ kind: 'landline', phoneNumber: crew.landline });
  }

  if(crew.email) {
    toReturn.doc.contact.email = [crew.email];
  }

  if(crew.street && crew.city) {
    toReturn.doc.address = {};
    if(!isNaN(Number(crew.street.split(' ').slice(-1)))) {
      toReturn.doc.address.number = Number(crew.street.split(' ').slice(-1)).toString();
      toReturn.doc.address.street = crew.street.split(' ').slice(0, -1).join(' ');
    }

    if(!isNaN(Number(crew.city.split(' ')[0]))) {
      toReturn.doc.address.zipCode = Number(crew.city.split(' ')[0]);
      toReturn.doc.address.city = crew.city.split(' ').slice(1).join(' ');
    } else toReturn.doc.address.city = crew.city;
    
  }

  if(crew.birth_date) {
    const splitDate = crew.date.split("-");
    toReturn.date = { day: Number(splitDate[2]), month: Number(splitDate[1]), year: Number(splitDate[0]) };
  }

  if(crew.bank_account) toReturn.doc.bankAccount = crew.bank_account;
  if(crew.year_started_volunteering) toReturn.doc.yearStarted = crew.year_started_volunteering;

  return toReturn;
};

