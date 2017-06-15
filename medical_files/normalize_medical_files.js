#!/usr/bin/env node

// Normalize medical files from Google Docs

const commandLineArgs = require('command-line-args')
const csv = require('csv');
const fs = require('fs');
 
const optionDefinitions = [
  { name: 'input', alias: 'i', type: String, defaultOption: true }
]

const options = commandLineArgs(optionDefinitions)

fs.readFile(options.input, (err, data) => {
  csv.parse(data, function(err, data){
    console.log(JSON.stringify( { docs: data.slice(1).map(normalizeChild) } ));
  });
});

const normalizeChild = (child) => {
  const toReturn =  {
    kind: 'type/child/v1',
    doc: {
      firstName: child[2],
      lastName: child[1],
      legacyAddress: {
        street: child[3].split(' ').slice(0, -1).join(' '),
        number: child[3].split(' ').slice(-1)[0],
        zipCode: Number(child[4].split(' ')[0]),
        city: child[4].split(' ').slice(1).join(' ')
      },
      legacyContact: {
        phone: [],
        email: []
      },
      contactPeople: [],
      legacyContactPeople: [],
      medicalInformation: {
        allergies: {
          allergies: [ child[19] ],
          extraInformation: child[20]
        },
        conditions: {
          conditions: [ child[21] ],
          extraInformation: child[22]
        },
        other: child[23]
      }
    }
  };

  if(toReturn.doc.medicalInformation.allergies.allergies[0] == '') {
    toReturn.doc.medicalInformation.allergies.allergies = [];
  }

  if(toReturn.doc.medicalInformation.conditions.conditions[0] == '') {
    toReturn.doc.medicalInformation.conditions.conditions = [];
  }

  if(child[5]) {
    toReturn.doc.legacyContact.phone = [ { kind: 'landline', phoneNumber: child[5] } ];
  }

  if(child[6]) {
    toReturn.doc.birthDate = {
      day: Number(child[6].split('/')[0]),
      month: Number(child[6].split('/')[1]),
      year: Number(child[6].split('/')[2])
    }
  }

  if(child[8]) {
    toReturn.doc.gender = child[8] == 'Man' ? 'male' : 'female';
  }

  if(child[9]) {
    toReturn.doc.legacyContactPeople.push(makeContactPerson(child[9], child[10], child[11]));
  }

  if(child[12]) {
    toReturn.doc.legacyContactPeople.push(makeContactPerson(child[12], child[13], child[14]));
  }

  if(child[15]) {
    toReturn.doc.legacyContactPeople.push(makeContactPerson(child[15], child[16], child[17]));
  }

  if(child[18]) {
    toReturn.doc.familyDoctor = child[18];
  }

  return toReturn;
};

const makeContactPerson = (name, phone, relationship) => {
  const obj = {
    name: name,
    contact: {
      phone: [],
      email: []
    }
  };

  if(relationship) obj.relationship = relationship;

  if(phone) obj.contact.phone.push({ phoneNumber: phone });

  return obj;
};

