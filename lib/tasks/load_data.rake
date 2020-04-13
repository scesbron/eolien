# frozen_string_literal: true

require 'csv'
namespace :load_data do
  desc "Load Cit'Eole"
  task cit_eole: :environment do
    csv_text = File.read("#{Rails.root}/data/citeole.csv")
    csv = CSV.parse(csv_text, headers: true, col_sep: ',')
    share_amount = 200
    citeole = Company.find_or_create_by(name: 'Cit\'Eole Hyrôme')
    loan = Loan.find_or_create_by(name: 'Compte courant d\'associé', amount: share_amount * 4, company: citeole)
    share = Share.find_or_create_by(name: 'Action', amount: share_amount, company: citeole)
    first_date = Date.new(2019, 1, 1)
    second_date = Date.new(2019, 2, 11)
    third_date = Date.new(2019, 5, 28)
    csv.each do |row|
      user = User.new(
        company: citeole,
        password: rand(36**12).to_s(36),
        username: row['username'],
        firstname: row['firstname'],
        lastname: row['lastname'],
        email: row['email'],
        phone: row['phone'],
        birth_date: row['birth_date'] ? Date.strptime(row['birth_date'], '%d/%m/%Y') : nil,
        address: row['address'],
        additional_address: row['additional_address'],
        zip_code: row['zip_code'],
        city: row['city']
      )
      if user.valid?
        user.save!
        if row['first_share']
          quantity = row['first_share'].to_i / share_amount
          UserShare.create!(user: user, share: share, date: first_date, quantity: quantity)
          UserLoan.create!(user: user, loan: loan, date: first_date, quantity: quantity)
        end
        if row['second_share']
          quantity = row['second_share'].to_i / share_amount
          UserShare.create!(user: user, share: share, date: second_date, quantity: quantity)
          UserLoan.create!(user: user, loan: loan, date: second_date, quantity: quantity)
        end
        if row['third_share']
          quantity = row['third_share'].to_i / share_amount
          UserShare.create!(user: user, share: share, date: third_date, quantity: quantity)
          UserLoan.create!(user: user, loan: loan, date: third_date, quantity: quantity)
        end
      else
        puts "#{user.firstname} #{user.lastname} : #{user.username} : #{user.errors.full_messages}"
      end
    end
  end

  desc 'Load eo-lien'
  task eo_lien: :environment do
    csv_text = File.read("#{Rails.root}/data/eolien.csv")
    csv = CSV.parse(csv_text, headers: true, col_sep: ';')
    company = Company.find_by(name: 'Eo-Lien')
    csv.each do |row|
      user = User.new(row.to_hash.merge(company_id: company.id, password: rand(36**12).to_s(36)))
      if user.valid?
        user.save
      else
        puts user.errors.full_messages
      end
    end
  end

  desc 'Load SEVE'
  task seve: :environment do
    csv_text = File.read("#{Rails.root}/data/seve.csv")
    csv = CSV.parse(csv_text, headers: true, col_sep: ';')
    company = Company.find_by(name: 'SEVE')
    csv.each do |row|
      user = User.new(row.to_hash.merge(company_id: company.id, password: rand(36**12).to_s(36)))
      if user.valid?
        user.save
      else
        puts "#{user.errors.full_messages} : #{user.inspect}"
      end
    end
  end

  task eo_lien_actions: :environment do
    csv_text = File.read("#{Rails.root}/data/actionnaires.csv")
    csv = CSV.parse(csv_text, headers: true, col_sep: ',')
    company = Company.find_by(name: 'Eo-Lien')
    csv.each do |row|
      user = User.find_by(company: company, shareholder_number: row['number'])
      if user
        user.update(
          start_up_actions: (row['initial'] || 0).to_i,
          first_round_actions: (row['first'] || 0).to_i,
          first_round_obligations: (row['first'] || 0).to_i * 11,
          second_round_actions: (row['second'] || 0).to_i,
          second_round_obligations: (row['second'] || 0).to_i * 11
        )
      else
        puts "Unknown user : #{row['number']}"
      end
    end
  end
end
