module Admin
  class TestResultsController < ApplicationController
    before_action :authenticate_user!

    def index
      @test_results = TestResult.all
    end
  end
end
