#!/usr/bin/env node

const _ = require('underscore');

var input = '';

process.stdin.on('readable', () => {
  var chunk = process.stdin.read();
  if (chunk !== null) {
    input += chunk;
  }
});

process.stdin.on('end', () => {
  var parsed = JSON.parse(input);
  var output = parsed.map(normalizeChild);
  process.stdout.write(JSON.stringify( { docs: output } ));
});

const normalizeChild = (child) => {
  const toReturn = {
    kind: 'type/child/v1',
    _id: child.id,

    doc: {
      firstName: child.first_name,
      lastName: child.last_name,
      legacyContact: {
        phone: [],
        email: []
      },
      legacyAddress: {},
      medicalInformation: {},
      contactPeople: []
    }
  };

  if(child.mobile_phone) {
    toReturn.doc.legacyContact.phone.push({ kind: 'mobile', phoneNumber: child.mobile_phone });
  }

  if(child.landline) {
    toReturn.doc.legacyContact.phone.push({ kind: 'landline', phoneNumber: child.landline });
  }

  if(child.street) toReturn.doc.legacyAddress.street = child.street;
  if(child.street_number) toReturn.doc.legacyAddress.number = child.street_number;
  if(child.zip_code) toReturn.doc.legacyAddress.zipCode = Number(child.zip_code);
  if(child.city) toReturn.doc.legacyAddress.city = child.city;

  if(child.birth_date) {
    const splitDate = child.birth_date.split("-");
    toReturn.doc.birthDate = { year: Number(splitDate[0]), month: Number(splitDate[1]), day: Number(splitDate[2]) };
  }

  toReturn.doc.medicalInformation = {};
  return toReturn;
};

