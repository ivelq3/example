RSpec.shared_context 'with employee assistant admin' do
  let(:block) { create(:department) }
  let(:department) { create(:department, parent: block) }
  let(:admin) { create(:user, department:) }
  let(:assistant) { create(:user, department:) }
  let(:employee) { create(:user, department:) }

  before do
    create(:bonus_payment_role, :admin, user: admin, department: block)
    create(:bonus_payment_role, user: assistant, department: block)
  end
end
