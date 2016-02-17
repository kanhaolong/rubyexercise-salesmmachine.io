require_relative '../lib/csv/csv_importer'
require_relative '../lib/csv/Integration_contact'

csv_path = {csv_file:'/Users/kanhaolong/Desktop/ruby-exercice-master/spec/contacts.csv'}
@num = 1
importer = CsvImporter.new
contacts = importer.import(csv_path)

RSpec.describe CsvImporter do
  it 'must generate contacts' do
      #expect(contacts).to be_an_instance_of(Array)
      # TODO Complete tests
      # for each contact minimal values are name and email, all others fields are puts in data hash
      # you have to loop over each extracted contact and test things on it, this is just an example, feel free to improve it
      # you also can take a specific contact by its index and check all values, to be sure that the field mapping is working
      contacts.each do |contact|
          expect(contact).to be_an_instance_of(Hash)
          expect(contact["Name"]).not_to be_nil      
          expect(contact["Email"]).not_to be_nil
          expect(contact["data"]).to be_an_instance_of(Hash)
      end
      expect(contacts[0]["data"]['City']).to eql('Paris') 
      expect(contacts[1]["data"]['City']).to eql('Beijing') 
  end
end

RSpec.describe Integrationcontact do
  it 'must integrate contacts to Pipedirve CRM' do
    Intergrationforcontact = Integrationcontact.new
     # email = row['Email']
     # id = row['data']['Id']
     # city = row['data']['City']

     #put_contact(contacts)
     #delete_contact(2)
     #updatePerson(3,{:name => "newone"})
     #contactually_get_contacts
    get_contacts = Intergrationforcontact.get_contacts #get all contacts in our account of Pipedriver
    expect(get_contacts).to be_an_instance_of(Hash) #it should be returned as a Hash
    Intergrationforcontact.put_contact(contacts) #add contacts to Pipedriver using the informations in our local csv file
    search_contact = Intergrationforcontact.search_contact('Haolong Kan',0) # search contact by name
    expect(search_contact).to be_an_instance_of(Array)# it should be returned as an Array
    expect(search_contact[0]["name"]).to eql('Haolong Kan')
    expect(search_contact[0]["email"]).to eql('haolong.kan@epitech.eu')
    Intergrationforcontact.delete_contact(56)# delete the contact whoose Id is 0
    #search_contact = Intergrationforcontact.search_contact('Jérémie Doucy',0)
    #expect(search_contact.empty?).to eql(true)
    get_contacts2 = Intergrationforcontact.get_contacts
    expect(!get_contacts2.has_value?("Jérémie Doucy")).to eql(true)# it should not include the Name "Jérémie Doucy" casue I delete it before
    Intergrationforcontact.update_contact(57,{:email =>"1234567@163.com"})
    search_contact2 = Intergrationforcontact.search_contact('Haolong Kan',0) 
    expect(search_contact2[0]["email"]).to eql('1234567@163.com')
  end
end