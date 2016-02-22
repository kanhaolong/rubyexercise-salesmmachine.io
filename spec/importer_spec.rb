require_relative '../lib/csv/csv_importer'
require_relative '../lib/csv/Integration_contact'
require_relative '../lib/csv/Integration_organization'

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
    get_contacts = Intergrationforcontact.get_contacts('8247c424fe7ae35f57797aa5720c90c3c8baa850') #get all contacts in our account of Pipedriver
    expect(get_contacts).to be_an_instance_of(Hash) #it should be returned as a Hash
    Intergrationforcontact.put_contact(contacts,{:org_id => "4"},'8247c424fe7ae35f57797aa5720c90c3c8baa850') #add contacts to Pipedriver using the informations in our local csv file
    search_contact = Intergrationforcontact.search_contact('Haolong Kan',0,'8247c424fe7ae35f57797aa5720c90c3c8baa850') # search contact by name
    expect(search_contact).to be_an_instance_of(Array)# it should be returned as an Array
    expect(search_contact[0]["name"]).to eql('Haolong Kan')
    expect(search_contact[0]["email"]).to eql('haolong.kan@epitech.eu')
    Intergrationforcontact.delete_contact(63,'8247c424fe7ae35f57797aa5720c90c3c8baa850')# delete the contact whoose Id is 0
    #search_contact = Intergrationforcontact.search_contact('Jérémie Doucy',0)
    #expect(search_contact.empty?).to eql(true)
    get_contacts2 = Intergrationforcontact.get_contacts('8247c424fe7ae35f57797aa5720c90c3c8baa850')
    expect(!get_contacts2.has_value?("Jérémie Doucy")).to eql(true)# it should not include the Name "Jérémie Doucy" casue I delete it before
    Intergrationforcontact.update_contact(64,{:email =>"1234567@163.com"},'8247c424fe7ae35f57797aa5720c90c3c8baa850')
    search_contact2 = Intergrationforcontact.search_contact('Haolong Kan',0,'8247c424fe7ae35f57797aa5720c90c3c8baa850') 
    expect(search_contact2[0]["email"]).to eql('1234567@163.com')
  end
end

RSpec.describe 'Integrationorganization' do
  it 'must integrate organization' do
      Organizations=Organization.new
      Organizations.addOrganization("Slaesmachine",{},'8247c424fe7ae35f57797aa5720c90c3c8baa850')
      get_organ = Organizations.getOrganization(4,'8247c424fe7ae35f57797aa5720c90c3c8baa850')
      expect(get_organ).to be_an_instance_of(Hash)
      expect(get_organ["data"]["name"]).to eql('Slaesmachine')
      Organizations.updateOrganization(5,{:name=>"new"},'8247c424fe7ae35f57797aa5720c90c3c8baa850')
      get_find = Organizations.findOrganizationByName("new",'8247c424fe7ae35f57797aa5720c90c3c8baa850')
      expect(get_find[0]["name"]).to eql("new")
      get_persons = Organizations.getPersonsOfOrganization(4,'8247c424fe7ae35f57797aa5720c90c3c8baa850')
      expect(get_persons).to be_an_instance_of(Array)
      expect(get_persons[0]["email"][0]["value"]).to eql('jeremie@salesmachine.io')
  end
end
