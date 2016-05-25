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

  toReturn.type = 'type/child/v1'

  toReturn.firstName = child.first_name;
  toReturn.lastName = child.last_name;
  toReturn.attendances = [];

  if(child.mobile_phone) {
    toReturn.contact = {};
    toReturn.contact.phone = [];
    toReturn.contact.phone.push({ kind: 'mobile', phoneNumber: child.mobile_phone });
  }

  if(child.landline) {
    toReturn.contact = toReturn.contact || {};
    toReturn.contact.phone = toReturn.contact.phone || [];
    toReturn.contact.phone.push({ kind: 'landline', phoneNumber: child.landline });
  }

  if(child.street && child.city) {
    toReturn.address = {};
    if(!isNaN(Number(child.street.split(' ').slice(-1)))) {
      toReturn.address.number = Number(child.street.split(' ').slice(-1));
      toReturn.address.street = child.street.split(' ').slice(0, -1).join(' ');
    }

    if(!isNaN(Number(child.city.split(' ')[0]))) {
      toReturn.address.zipCode = Number(child.city.split(' ')[0]);
      toReturn.address.city = child.city.split(' ').slice(1).join(' ');
    } else toReturn.address.city = child.city;
    
  }

  if(child.attendances) {
    toReturn.attendances = child.attendances;
  }

  if(child.birth_date) toReturn.birthDate = child.birth_date;

  return toReturn;
};

