# В архиве letters вы найдете письма Льва Толстого в формате XML.
# Вам надо клонировать репозиторий с дз, выполнить задание и закоммитить изменения.
# Не меняйте структуру репозитория. Не переименовывайте файл с заданием.
# Не переименовывайте переменные. 

# Вам надо извлечь из каждого файла том, дату и адресата, и собрать эти данные в одну таблицу. 
# дата письма: в header — тег correspAction, тип sending — тег date, атрибут when;
# адресат: в header – тег correspAction, тип receiving — имя получателя (текст)
# том: в header — biblScope, юнит vol — номер тома

# Применяйте trimws() к результату парсинга, чтобы избавиться от лишних строк. 

library(xml2)
library(dplyr)
library(purrr)

unzip("letters.zip")
my_xmls <- list.files("letters/", full.names = TRUE)

# Сначала напишите код для первого письма в датасете, чтобы потренироваться. 

test_xml <- my_xmls[1]
doc <- read_xml(test_xml) # ваш код здесь
ns <- xml_ns(doc) # ваш код здесь

print(ns)

  
# дата письма

date_nodes <- xml_find_all(doc, "//d1:correspAction[@type='sending']/d1:date", ns)
date <- xml_attr(date_nodes, "when") # ваш код здесь
date <- trimws(date)

print(date)

# адреdate# адресат письма

corresp_nodes <- xml_find_all(doc, "//d1:correspAction[@type='receiving']/d1:persName", ns)
corresp <- xml_text(corresp_nodes)
corresp <- trimws(corresp)# ваш код здесь
print(corresp)

# том 
vol_nodes <- xml_find_all(doc, "//d1:biblScope[@unit='vol']", ns)
vol <- xml_text(vol_nodes)
vol <- trimws(vol)# ваш код здесь
print(vol)

## Когда все получится, оберните свое решение в функцию read_letter().

result <- tibble(
  date = date,
  recipient = corresp,
  volume = vol
)

print(result)

read_letter <- function(xml_path) {
  doc <- read_xml(xml_path)
  ns <- xml_ns(doc)
  
  date_nodes <- xml_find_all(doc, "//d1:correspAction[@type='sending']/d1:date", ns)
  date <- xml_attr(date_nodes, "when")
  date <- trimws(date)
  
  corresp_nodes <- xml_find_all(doc, "//d1:correspAction[@type='receiving']/d1:persName", ns) # ваш код здесь 
  corresp <- xml_text(corresp_nodes)
  corresp <- trimws(corresp)
  
  vol_nodes <- xml_find_all(doc, "//d1:biblScope[@unit='vol']", ns)
  vol <- xml_text(vol_nodes)
  vol <- trimws(vol)
  
  
  # записываем в тиббл
  res <- tibble(
    date = ifelse(length(date) == 0, NA, date),
    recipient = ifelse(length(corresp) == 0, NA, corresp),
    volume = ifelse(length(vol) == 0, NA, vol)
  )
    # ваш код здесь


  return(res)
}


# Прочтите все письма в один тиббл при помощи map_dfr(). 
letters_tbl <- map_dfr(my_xmls, read_letter)# ваш код здесь
print(letters_tbl)
head(letters_tbl)

test_result <- read_letter(my_xmls[1])
print("Тест первого файла:")
print(test_result)
