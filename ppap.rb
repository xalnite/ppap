#!/usr/bin/ruby
require 'logger'
require 'optparse'
require 'securerandom'
require 'zip'

FILENAME_MAX_SUFFIX = 100
PASSWORD_MAX_LENGTH = 64
PASSWORD_UNSAFE_CHARS = Set.new(" \"'\\/:;*?<>|".chars)
PASSWORD_CHARSET = ('!'..'~').reject { |c| PASSWORD_UNSAFE_CHARS.include?(c) }

$debug = false
$encryption = true
$logger = nil
$logdev = nil
Zip.default_compression = Zlib::BEST_COMPRESSION
Zip.write_zip64_support = true
# to handle filenames in UTF-8 within the ZIP archive
# Zip.unicode_names = true
FN_ENCODING = 'CP932' # extends Shift_JIS

def logger(materialize = false)
  if $logger.nil?
    $logger = $logdev && (materialize || $debug) ? Logger.new($logdev) : Logger.new(STDOUT)
    $logger.level = $debug ? Logger::DEBUG : Logger::INFO
    $logger.formatter = proc do |severity, datetime, progname, msg|
      "[#{datetime.strftime('%Y-%m-%d %H:%M:%S.%3N')}] [#{severity}] #{msg}\n"
    end
  end
  $logger
end

def setlogger(dev)
  $logdev = dev
  $logger = nil
end

def generate_password(length = 16)
  length = PASSWORD_MAX_LENGTH if length > PASSWORD_MAX_LENGTH || length < 1
  SecureRandom.alphanumeric(length, chars: PASSWORD_CHARSET)
end

def archive(encrypter, archive, files)
  encrypter = Zip::NullEncrypter.new if encrypter.nil?
  Zip::OutputStream.open(archive, encrypter: encrypter) do |zos|
    files.each do |file|
      encoded_name = File.basename(file).encode(FN_ENCODING, invalid: :replace, undef: :replace, replace: '_')
      zos.put_next_entry(encoded_name)
      zos.write(File.read(file, binmode: true))
    end
  end
  logger.debug { "archive created: #{archive}" }
end

def ppap(password, archive, files)
  if archive.to_s.empty?
    extension = File.extname(files[0])
    wo_extension = files[0].delete_suffix(extension)
    archive = "#{wo_extension}.zip"
    if File.exist?(archive)
      (0..FILENAME_MAX_SUFFIX).each do |i|
        archive = "#{wo_extension}-#{i}.zip"
        break unless File.exist?(archive)
      end
    end
    logger.debug { "archive name: #{archive}" }
  end
  setlogger("#{archive.delete_suffix('.zip')}.log")
  encrypter = nil
  if $encryption
    if password.to_s.empty?
      quarter = PASSWORD_MAX_LENGTH / 4
      password = generate_password(SecureRandom.random_number(quarter) + PASSWORD_MAX_LENGTH - quarter + 1)
      logger.debug { "password generated: #{password}" }
    end
    File.open("#{archive.delete_suffix('.zip')}-password.txt", 'w') do |f|
      f.puts("password is #{password}")
      logger.debug { "password file created: #{f.path}" }
    end
    encrypter = Zip::TraditionalEncrypter.new(password)
  end
  archive(encrypter, archive, files)
rescue StandardError => e
  logger(true).error { "error occurred: #{e.message}\n#{e.backtrace.join("\n")}" }
end

if __FILE__ == $0
  archive = nil
  password = nil
  option = OptionParser.new
  option.on('-p', '--password PASSWORD', 'Set password for the zip file') do |p|
    password = p
  end
  option.on('-a', '--archive ARCHIVE', 'Set archive file name') do |a|
    archive = a
  end
  option.on('-d', '--debug', 'Enable debug mode') do
    $debug = true
  end
  option.on('-n', '--no-encryption', 'Disable encryption') do
    $encryption = false
  end
  files = option.parse(ARGV)
  ppap(password, archive, files)
end
