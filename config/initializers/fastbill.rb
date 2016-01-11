#   Copyright (c) 2012-2016, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

Fastbill::Automatic.api_key = Rails.application.secrets.fastbill_api_key
Fastbill::Automatic.email   = Rails.application.secrets.fastbill_email
