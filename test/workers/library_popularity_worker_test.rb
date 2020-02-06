#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'test_helper'

class LibraryPopularityWorkerTest < ActiveSupport::TestCase
  let(:library) { Library.new }
  let(:worker) { LibraryPopularityWorker.new }

  def set_stubs library, base, num, num_current
    library.stubs("#{base}_count").returns(num)
    library.stub_chain(base, :where, :count).returns(num_current)
  end

  describe '#popularity_for' do
    # first test: library with no comments or hearts should have popularity of 0.0
    it 'should calculate 0 for library with no hearts or comments' do
      set_stubs(library, :hearts, 0, 0)
      set_stubs(library, :comments, 0, 0)
      library.updated_at = Time.now
      worker.instance_variable_set('@library', library)
      assert_equal worker.send(:popularity), 0, 'new library'
    end

    # second test: create several hearts and comments
    # twenty-five hearts total = 25 x 1 -> 25
    # six hearts with an age < 3 days, they count extra = 6 x 1 -> 6
    # ten comments total = 10 x 5 -> 50
    # three comments with an < 3 days, they count extra = 3 x 5 -> 15
    # in sum: 96
    # library is younger than 3 days, so popularity = 96 * 10 -> 960
    it 'should calculate correct value for library with hearts and comments' do
      set_stubs(library, :hearts, 25, 6)
      set_stubs(library, :comments, 10, 3)
      library.updated_at = Time.now
      worker.instance_variable_set('@library', library)
      assert_equal worker.send(:popularity), 960, 'library with hearts and comments'
    end

    # third test: set different updated_at values for the library
    # between 3 and 7 days: factor 2
    it 'should use a factor of 2 for a library aged 4 days' do
      set_stubs(library, :hearts, 25, 0)
      set_stubs(library, :comments, 0, 0)
      library.updated_at = 4.days.ago
      worker.instance_variable_set('@library', library)
      assert_equal worker.send(:popularity), 50, 'library updated 4 days ago'
    end

    # fourth test: between 3 and 7 days: factor 2
    it 'should use a factor of 2 for a library aged 6 days' do
      set_stubs(library, :hearts, 25, 0)
      set_stubs(library, :comments, 0, 0)
      library.updated_at = 6.days.ago
      worker.instance_variable_set('@library', library)
      assert_equal worker.send(:popularity), 50, 'library updated 6 days ago'
    end

    # fifth test: older than 7 days: factor 1
    it 'should use a factor of 1 for a library aged 8 days' do
      set_stubs(library, :hearts, 25, 0)
      set_stubs(library, :comments, 0, 0)
      library.updated_at = 8.days.ago
      worker.instance_variable_set('@library', library)
      assert_equal worker.send(:popularity), 25, 'library updated 8 days ago'
    end
  end

  describe '#perform' do
    it 'perform should call popularity_for to update the popularity database column' do
      library_db = create(:library)
      worker.stubs(:popularity).returns(50)
      worker.perform library_db.id
      assert_equal library_db.reload.popularity, 50, 'library_db has popularity of 50'
    end
  end
end
