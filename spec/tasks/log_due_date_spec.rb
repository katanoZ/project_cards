require 'rake_helper'

describe 'log:due_date' do
  let(:task) { Rake.application['log:due_date'] }
  before { allow(Log).to receive(:create_due_date_notification_logs!) }

  it 'Log.create_due_date_notification_logs!が呼び出されること' do
    task.invoke
    expect(Log).to have_received(:create_due_date_notification_logs!)
  end
end
