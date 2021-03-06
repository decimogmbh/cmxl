require 'spec_helper'

describe Cmxl do

  context 'with details' do
    subject { Cmxl.parse( mt940_file('statement-details-mt940') ).first.transactions.first }

    it { expect(subject).to be_debit }
    it { expect(subject).to_not be_credit }
    it { expect(subject.funds_code).to eql('D') }
    it { expect(subject.date).to eql(Date.new(2014,9,1)) }
    it { expect(subject.entry_date).to eql(Date.new(2014,9,2)) }
    it { expect(subject.amount).to eql(1.62) }
    it { expect(subject.amount_in_cents).to eql(162) }
    it { expect(subject.to_h).to eql(
      {
        "date" => Date.new(2014,9,1),
        "sha" => "3c5e65aa3d3878b06b58b6f1ae2f3693004dfb04e3ab7119a1c1244e612293da",
        "entry_date" => Date.new(2014,9,2),
        "funds_code" => "D",
        "currency_letter" => "R",
        "amount" => 1.62,
        "swift_code" => "NTRF",
        "reference" => "0000549855700010",
        "bank_reference" => "025498557/000001",
        "amount_in_cents" => 162,
        "sign" => -1,
        "debit" => true,
        "credit" => false,
        "bic" => "HYVEDEMMXXX",
        "iban" => "HUkkbbbsssskcccccccccccccccx",
        "name" => "Peter Pan",
        "sepa" => {
          "KREF" => "",
          "EREF" => "TRX-0A4A47C3-F846-4729-8A1B-5DF620F",
          "MREF" => "CAC97D2144174318AC18D9BF815BD4FB",
          "CRED" => "DE98ZZZ09999999999",
          "SVWZ" => "FOO TRX-0A4A47C3-F846-4729-8A1B-5DF620F"
        },
        "information" => "KREF+EREF+TRX-0A4A47C3-F846-4729-8A1B-5DF620FMREF+CAC97D2144174318AC18D9BF815BD4FBCRED+DE98ZZZ09999999999SVWZ+FOO TRX-0A4A47C3-F846-4729-8A1B-5DF620F",
        "description" => "SEPA LASTSCHRIFT KUNDE",
        "sub_fields" => {
          "00" => "SEPA LASTSCHRIFT KUNDE",
          "10" => "281",
          "20" => "KREF+EREF+TRX-0A4A47C3-F846-4729",
          "21" => "-8A1B-5DF620F",
          "22" => "MREF+CAC97D2144174318AC18D9",
          "23" => "BF815BD4FB",
          "24" => "CRED+DE98ZZZ09999999999",
          "25" => "SVWZ+FOO TRX-0A4A47C3-F84",
          "26" => "6-4729-8A1B-5DF620F",
          "30" => "HYVEDEMMXXX",
          "31" => "HUkkbbbsssskcccccccccccccccx",
          "32" => "Peter Pan",
          "99"  =>  "",
          "34" => "171"
        },
        "transaction_code" => "171",
        "details" => "?00SEPA LASTSCHRIFT KUNDE?10281?20KREF+EREF+TRX-0A4A47C3-F846-4729?21-8A1B-5DF620F?22MREF+CAC97D2144174318AC18D9?23BF815BD4FB?24CRED+DE98ZZZ09999999999?25SVWZ+FOO TRX-0A4A47C3-F84?266-4729-8A1B-5DF620F?30HYVEDEMMXXX?31HUkkbbbsssskcccccccccccccccx?32Peter Pan?99?34171"
        }
      )
    }
  end

  context 'without details' do
    subject { Cmxl.parse( mt940_file('statement-mt940') ).first.transactions.first }

    it { expect(subject).to be_debit }
    it { expect(subject).to_not be_credit }
    it { expect(subject.date).to eql(Date.new(2014,9,1))}
    it { expect(subject.entry_date).to eql(Date.new(2014,9,2)) }
    it { expect(subject.amount).to eql(1.62) }
    it { expect(subject.amount_in_cents).to eql(162) }
    it 'does not include any details in its hash representation' do
      expect(subject.to_h).to eql({
        "date" => Date.new(2014,9,1),
        "sha" => "3c5e65aa3d3878b06b58b6f1ae2f3693004dfb04e3ab7119a1c1244e612293da",
        "entry_date"=>Date.new(2014,9,2),
        "funds_code" => "D",
        "currency_letter" => "R",
        "amount" => 1.62,
        "swift_code" => "NTRF",
        "reference" => "0000549855700010",
        "bank_reference" => "025498557/000001",
        "amount_in_cents" => 162,
        "sign" => -1,
        "debit" => true,
        "credit" => false
      })
    end
  end

  describe 'statement with detailed end balance' do
    subject { Cmxl.parse( mt940_file('mt940-with-detailed-end-balance') ).first.transactions.first }

    it 'includes correct iban' do
      expect(subject.iban).to eq('234567')
    end

    it 'includes correct bic' do
      expect(subject.bic).to eq('10020030')
    end
  end
end
