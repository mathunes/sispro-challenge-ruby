require_relative "../models/discipline"
require_relative "../models/enrollment"
require_relative "../models/student"
require_relative "csv_parser_service"

class FileService
    CSV_HEADER = "MATRICULA,COD_DISCIPLINA,COD_CURSO,NOTA,CARGA_HORARIA,ANO_SEMESTRE"

    def self.read_file(file_path)
        begin
            file = File.open(file_path, "r")
            file.read
        rescue IOError
            raise "An error occurred while reading the file."
        ensure
            file.close if file
        end
    end

    def self.file_exist?(file_path)
        if File.exist?(file_path)
            true
        else
            puts "File does not exist."
            false
        end
    end

    def self.is_csv_file?(file_path)
        if File.extname(file_path) == ".csv"
            true
        else
            puts "File does not csv."
            false
        end
    end

    def self.is_csv_file_formatted?(file_content)
        csv_header = file_content.split("\n")[0].strip

        if csv_header == CSV_HEADER
            true
        else
            puts "The CSV file is not in the expected format."
            false
        end
    end

    def self.cluster_registers_by_student_code(file_content)
        clusters = {}
        
        file_content_array = file_content.split("\n").drop(1)

        file_content_array.each do |file_content_array_item|
            student_code = file_content_array_item.split(",")[0]
            
            begin
                discipline, enrollment, student = CsvParserService.row_to_objects(file_content_array_item)

                if !clusters.has_key?(student_code)
                    clusters[student_code] = []
                end
                clusters[student_code] << [discipline, enrollment, student]     
            rescue ArgumentError => e
                puts e.message
            end
        end
        clusters
    end

    def self.cluster_registers_by_course_code(file_content)
        clusters = {}
        
        file_content_array = file_content.split("\n").drop(1)

        file_content_array.each do |file_content_array_item|
            course_code = file_content_array_item.split(",")[2]
            
            begin
                discipline, enrollment, student = CsvParserService.row_to_objects(file_content_array_item)

                if !clusters.has_key?(course_code)
                    clusters[course_code] = []
                end
                clusters[course_code] << [discipline, enrollment, student]
            rescue ArgumentError => e
                puts e.message
            end 
        end
        clusters
    end
end  