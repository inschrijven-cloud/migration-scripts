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
  var output = parsed.map(normalizeChild);
  process.stdout.write(JSON.stringify( { docs: output } ));
});

var normalizeChild = (child) => {
  var toReturn = {};
  toReturn.doc = {};

  toReturn.kind = 'type/child/v1'

  toReturn.doc.firstName = child.first_name;
  toReturn.doc.lastName = child.last_name;
  toReturn.doc.attendances = [];

  if(child.mobile_phone) {
    toReturn.doc.contact = {};
    toReturn.doc.contact.phone = [];
    toReturn.doc.contact.phone.push({ kind: 'mobile', phoneNumber: child.mobile_phone });
  }

  if(child.landline) {
    toReturn.doc.contact = toReturn.doc.contact || {};
    toReturn.doc.contact.phone = toReturn.doc.contact.phone || [];
    toReturn.doc.contact.phone.push({ kind: 'landline', phoneNumber: child.landline });
  }

  if(child.street && child.city) {
    toReturn.doc.address = {};
    if(!isNaN(Number(child.street.split(' ').slice(-1)))) {
      toReturn.doc.address.number = Number(child.street.split(' ').slice(-1));
      toReturn.doc.address.street = child.street.split(' ').slice(0, -1).join(' ');
    }

    if(!isNaN(Number(child.city.split(' ')[0]))) {
      toReturn.doc.address.zipCode = Number(child.city.split(' ')[0]);
      toReturn.doc.address.city = child.city.split(' ').slice(1).join(' ');
    } else toReturn.doc.address.city = child.city;
    
  }

  if(child.attendances) {
    toReturn.doc.attendances = child.attendances;
  }

  if(child.birth_date) {
    const splitDate = child.birth_date.split("-");
    toReturn.doc.birthDate = { year: Number(splitDate[0]), month: Number(splitDate[1]), day: Number(splitDate[2]) };
  }

  return toReturn;
};

