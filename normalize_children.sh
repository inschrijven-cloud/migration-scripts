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

var normalizeChild = (child) => {
  var toReturn = {};
  toReturn.doc = {};

  toReturn.kind = 'type/child/v1';
  toReturn._id = child.id;

  toReturn.doc.firstName = child.first_name;
  toReturn.doc.lastName = child.last_name;
  toReturn.doc.attendances = [];

  toReturn.doc.contact = {};
  toReturn.doc.contact.phone = [];

  toReturn.doc.contact.email = [];

  if(child.mobile_phone) {
    toReturn.doc.contact.phone.push({ kind: 'mobile', phoneNumber: child.mobile_phone });
  }

  if(child.landline) {
    toReturn.doc.contact.phone.push({ kind: 'landline', phoneNumber: child.landline });
  }

  toReturn.doc.address = {};

  if(child.street) toReturn.doc.address.street = child.street;
  if(child.street_number) toReturn.doc.address.number = child.street_number;
  if(child.zip_code) toReturn.doc.address.zipCode = Number(child.zip_code);
  if(child.city) toReturn.doc.address.city = child.city;
 
  if(child.attendances) {
    toReturn.doc.attendances = normalizeAttendances(child.attendances);
  }

  if(child.birth_date) {
    const splitDate = child.birth_date.split("-");
    toReturn.doc.birthDate = { year: Number(splitDate[0]), month: Number(splitDate[1]), day: Number(splitDate[2]) };
  }

  return toReturn;
};

var normalizeAttendances = (attendances) => {
  var grouped = _.groupBy(
    attendances.map(att => { return { day:  att.split('/')[0], shiftId: att.split('/')[1] } }),
    att => att.day
  );

  return _.values(_.mapObject(grouped, (value, key) => { return { day: key, shifts: _.map(value, x => x.shiftId) } }));
}

