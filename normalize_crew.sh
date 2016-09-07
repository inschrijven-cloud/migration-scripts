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
  toReturn._id = crew.id;

  toReturn.doc.firstName = crew.first_name;
  toReturn.doc.lastName = crew.last_name;
  toReturn.doc.contact = {};

  toReturn.doc.contact.phone = [];
  toReturn.doc.contact.email = [];

  if(crew.mobile_phone) {
    toReturn.doc.contact.phone.push({ kind: 'mobile', phoneNumber: crew.mobile_phone });
  }

  if(crew.landline) {
    toReturn.doc.contact.phone.push({ kind: 'landline', phoneNumber: crew.landline });
  }

  if(crew.email) {
    toReturn.doc.contact.email = [crew.email];
  }

  toReturn.doc.address = {};

  if(crew.street && crew.city) {
    toReturn.doc.address.number = crew.street_number;
    toReturn.doc.address.street = crew.street;

    toReturn.doc.address.zipCode = Number(crew.zip_code);
    toReturn.doc.address.city = crew.city;
  }

  if(crew.birthdate) {
    const splitDate = crew.birthdate.split("-");
    toReturn.doc.birthDate = { day: Number(splitDate[2]), month: Number(splitDate[1]), year: Number(splitDate[0]) };
  }

  if(crew.bank_account) toReturn.doc.bankAccount = crew.bank_account;
  if(crew.year_started_volunteering) toReturn.doc.yearStarted = crew.year_started_volunteering;

  return toReturn;
};

