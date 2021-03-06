﻿#Область ОписаниеПеременных

&НаКлиенте
Перем КонтекстЯдра;
&НаКлиенте
Перем Утверждения;
&НаКлиенте
Перем СтроковыеУтилиты;
&НаКлиенте
Перем ОтборПоПрефиксу;
&НаКлиенте
Перем ПрефиксОбъектов;
&НаКлиенте
Перем ИсключенияИзПроверок;
&НаКлиенте
Перем ХранилищеВариантовОтчетов;
&НаКлиенте
Перем КаталогиВнешнихОтчетов;

#КонецОбласти

#Область ИнтерфейсТестирования

&НаКлиенте
Процедура Инициализация(КонтекстЯдраПараметр) Экспорт
	
	КонтекстЯдра = КонтекстЯдраПараметр;
	Утверждения = КонтекстЯдра.Плагин("БазовыеУтверждения");
	СтроковыеУтилиты = КонтекстЯдра.Плагин("СтроковыеУтилиты");
	
	ПутьНастройки = "Тесты";
	Настройки(КонтекстЯдра, ПутьНастройки);
		
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьНаборТестов(НаборТестов, КонтекстЯдра) Экспорт
	
	Инициализация(КонтекстЯдра);
	
	Если Не ВыполнятьТест(КонтекстЯдра) Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ХранилищеВариантовОтчетов) Тогда
		Возврат;
	КонецЕсли;
		
	НаборТестов.НачатьГруппу("Отчеты", Ложь);
	мОтчеты = Отчеты(ПрефиксОбъектов, ОтборПоПрефиксу);	
	Для Каждого Отчет Из мОтчеты Цикл
		ИмяПроцедуры = "ТестДолжен_ПроверитьХранилищеВариантовОтчетов";
		НаборТестов.Добавить(ИмяПроцедуры, НаборТестов.ПараметрыТеста(Отчет.Имя, Отчет.ПолноеИмя), Отчет.Имя);	
	КонецЦикла;
	
	Для Каждого КаталогВнешнихОтчетов Из КаталогиВнешнихОтчетов Цикл
		ФайлыВнешнихОтчетов = НайтиФайлы(КаталогВнешнихОтчетов, "*.erf", Истина);
		Если ФайлыВнешнихОтчетов.Количество() Тогда
			ИмяГруппы = СтроковыеУтилиты.ПодставитьПараметрыВСтроку("Внешние отчеты [%1]", КаталогВнешнихОтчетов);
			НаборТестов.НачатьГруппу(ИмяГруппы, Истина);
			Для Каждого ФайлВнешнегоОтчета Из ФайлыВнешнихОтчетов Цикл 
				ИмяПроцедуры = "ТестДолжен_ПроверитьХранилищеВариантовВнешнихОтчетов";
				НаборТестов.Добавить(
				ИмяПроцедуры, 
				НаборТестов.ПараметрыТеста(ФайлВнешнегоОтчета.Имя, ФайлВнешнегоОтчета.ПолноеИмя), 
				ФайлВнешнегоОтчета.Имя);	
			КонецЦикла;			
		КонецЕсли;
	КонецЦикла;
			
КонецПроцедуры

#КонецОбласти

#Область РаботаСНастройками

&НаКлиенте
Процедура Настройки(КонтекстЯдра, Знач ПутьНастройки)

	Если ЗначениеЗаполнено(Объект.Настройки) Тогда
		Возврат;
	КонецЕсли;
	
	ОтборПоПрефиксу = Ложь;
	ПрефиксОбъектов = "";
	КаталогиВнешнихОтчетов = Новый Массив;
	ИсключенияИзПроверок = Новый Соответствие;
	ПлагинНастроек = КонтекстЯдра.Плагин("Настройки");
	Объект.Настройки = ПлагинНастроек.ПолучитьНастройку(ПутьНастройки);
	Настройки = Объект.Настройки;
	
	Если Не ЗначениеЗаполнено(Объект.Настройки) Тогда
		Объект.Настройки = Новый Структура(ПутьНастройки, Неопределено);
		Возврат;
	КонецЕсли;
	
	Если Настройки.Свойство("Параметры") И Настройки.Параметры.Свойство("Префикс") Тогда
		ПрефиксОбъектов = Настройки.Параметры.Префикс;		
	КонецЕсли;
	
	Если Настройки.Свойство(ИмяТеста()) И Настройки[ИмяТеста()].Свойство("КаталогиВнешнихОтчетов") Тогда
		КаталогиВнешнихОтчетов = ОбработатьОтносительныеПути(
									Настройки[ИмяТеста()].КаталогиВнешнихОтчетов, 
									КонтекстЯдра);
	КонецЕсли;
	
	Если Настройки.Свойство(ИмяТеста()) И Настройки[ИмяТеста()].Свойство("ОтборПоПрефиксу") Тогда
		ОтборПоПрефиксу = Настройки[ИмяТеста()].ОтборПоПрефиксу;		
	КонецЕсли;
	
	Если Настройки.Свойство(ИмяТеста()) И Настройки[ИмяТеста()].Свойство("ХранилищеВариантовОтчетов") Тогда
		ХранилищеВариантовОтчетов = Настройки[ИмяТеста()].ХранилищеВариантовОтчетов;		
	КонецЕсли;
	
	Если Настройки.Свойство(ИмяТеста()) И Настройки[ИмяТеста()].Свойство("ИсключенияИзПроверок") Тогда
		ИсключенияИзПроверок(Настройки);
	КонецЕсли;
			
КонецПроцедуры

&НаКлиенте
Процедура ИсключенияИзПроверок(Настройки)

	Для Каждого ИсключенияИзПроверокПоОбъектам Из Настройки[ИмяТеста()].ИсключенияИзпроверок Цикл
		Для Каждого ИсключениеИзПроверок Из ИсключенияИзПроверокПоОбъектам.Значение Цикл
			ИсключенияИзПроверок.Вставить(ВРег(ИсключенияИзПроверокПоОбъектам.Ключ + "." + ИсключениеИзПроверок), Истина); 	
		КонецЦикла;
	КонецЦикла;	

КонецПроцедуры

#КонецОбласти

#Область Тесты

&НаКлиенте
Процедура ТестДолжен_ПроверитьХранилищеВариантовОтчетов(ИмяОтчета, ПолноеИмяОтчета) Экспорт
	
	ПропускатьТест = ПропускатьТест(ПолноеИмяОтчета);
	
	Результат = ПроверитьХранилищеВариантовОтчетов(ИмяОтчета, ХранилищеВариантовОтчетов);
	Если Не Результат И ПропускатьТест.Пропустить Тогда
		Утверждения.ПропуститьТест(ПропускатьТест.ТекстСообщения);
	Иначе
		Утверждения.Проверить(Результат, ТекстСообщения(ИмяОтчета));
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПроверитьХранилищеВариантовОтчетов(ИмяОтчета, ХранилищеВариантовОтчетов)
	
	Отчет = Метаданные.Отчеты.Найти(ИмяОтчета);	
	Хранилище = Метаданные.ХранилищаНастроек.Найти(ХранилищеВариантовОтчетов);
	
	Возврат Метаданные.ХранилищеВариантовОтчетов = Хранилище 
			Или Отчет.ХранилищеВариантов = Хранилище;	
			
КонецФункции

&НаКлиенте
Процедура ТестДолжен_ПроверитьХранилищеВариантовВнешнихОтчетов(ИмяОтчета, ПолноеИмяОтчета) Экспорт
	
	ПропускатьТест = ПропускатьТест(СтроковыеУтилиты.ПодставитьПараметрыВСтроку("ВнешнийОтчет.%1", ИмяОтчета));
	ДвоичныеДанные = Новый ДвоичныеДанные(ПолноеИмяОтчета);
	Адрес = ПоместитьВоВременноеХранилище(ДвоичныеДанные, ЭтотОбъект.УникальныйИдентификатор);
	
	Результат = ПроверитьХранилищеВариантовВнешнихОтчетов(Адрес, ХранилищеВариантовОтчетов);
	Если Не Результат.ХранилищеУстановлено И ПропускатьТест.Пропустить Тогда
		Утверждения.ПропуститьТест(ПропускатьТест.ТекстСообщения);
	ИначеЕсли Не Результат.ОтчетПодключен Тогда
		Утверждения.Проверить(Результат.ОтчетПодключен, Результат.ТекстОшибки);
	Иначе
		Утверждения.Проверить(Результат.ХранилищеУстановлено, ТекстСообщения(ИмяОтчета));
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПроверитьХранилищеВариантовВнешнихОтчетов(Адрес, ХранилищеВариантовОтчетов)
	
	Результат = Новый Структура;
	Результат.Вставить("ТекстОшибки", "");
	Результат.Вставить("ОтчетПодключен", Ложь);
	Результат.Вставить("ХранилищеУстановлено", Ложь);
	
	Попытка
		ДвоичныеДанные = ПолучитьИзВременногоХранилища(Адрес);
		ИмяФайлаОтчета = ПолучитьИмяВременногоФайла("erf");
		ДвоичныеДанные.Записать(ИмяФайлаОтчета);
		ВнешнийОтчет = ВнешниеОтчеты.Создать(ИмяФайлаОтчета).Метаданные();	
		Результат.ОтчетПодключен = Истина;
		УдалитьФайлы(ИмяФайлаОтчета);
	Исключение
		УдалитьФайлы(ИмяФайлаОтчета);
		Результат.ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		Возврат Результат;
	КонецПопытки;

	Хранилище = Метаданные.ХранилищаНастроек.Найти(ХранилищеВариантовОтчетов);
	
	Результат.ХранилищеУстановлено = (Метаданные.ХранилищеВариантовОтчетов = Хранилище 
									   Или ВнешнийОтчет.ХранилищеВариантов = Хранилище);	
			
	Возврат Результат;
			
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ПропускатьТест(ИмяОтчета)

	Результат = Новый Структура;
	Результат.Вставить("ТекстСообщения", "");
	Результат.Вставить("Пропустить", Ложь);
	
	Если ИсключенияИзПроверок.Получить(ВРег(ИмяОтчета)) <> Неопределено Тогда
		ШаблонСообщения = НСтр("ru = 'Объект ""%1"" исключен из проверки.'");
		Результат.ТекстСообщения = СтроковыеУтилиты.ПодставитьПараметрыВСтроку(ШаблонСообщения, ИмяОтчета);
		Результат.Пропустить = Истина;
		Возврат Результат;
	КонецЕсли;
		
	Возврат Результат;

КонецФункции 

&НаКлиенте
Функция ТекстСообщения(ИмяОтчета)

	ШаблонСообщения = НСтр("ru = 'Для отчета ""%1"" не указано хранилище вариантов отчета.'");
	ТекстСообщения = СтроковыеУтилиты.ПодставитьПараметрыВСтроку(ШаблонСообщения, ИмяОтчета);
	
	Возврат ТекстСообщения;

КонецФункции

&НаКлиенте
Функция ОбработатьОтносительныеПути(Знач ОтносительныеПути, КонтекстЯдра)

	Результат = Новый Массив;
	
	Для Каждого ОтносительныйПуть Из ОтносительныеПути Цикл
		
		Если Лев(ОтносительныйПуть, 1) = "." И ЗначениеЗаполнено(КонтекстЯдра.Объект.КаталогПроекта) Тогда
			ОтносительныйПуть = СтроковыеУтилиты.ПодставитьПараметрыВСтроку(
									"%1%2", 
									КонтекстЯдра.Объект.КаталогПроекта, 
									Сред(ОтносительныйПуть, 2));
		КонецЕсли;
		
		ОтносительныйПуть = СтрЗаменить(ОтносительныйПуть, "\\", "\");
		
		Если Результат.Найти(ОтносительныйПуть) = Неопределено Тогда
			Результат.Добавить(ОтносительныйПуть);
		КонецЕсли;
	
	КонецЦикла;
	
	Возврат Результат;

КонецФункции 

&НаСервере
Функция ИмяТеста()
	Возврат РеквизитФормыВЗначение("Объект").Метаданные().Имя;
КонецФункции

&НаКлиенте
Функция ВыполнятьТест(КонтекстЯдра)
	
	ВыполнятьТест = Истина;
	ПутьНастройки = "Тесты";
	Настройки(КонтекстЯдра, ПутьНастройки);
	Настройки = Объект.Настройки;
	
	Если Не ЗначениеЗаполнено(Настройки) Тогда
		Возврат ВыполнятьТест;
	КонецЕсли;
		
	Если ТипЗнч(Настройки) = Тип("Структура") 
		И Настройки.Свойство("Параметры") 
		И Настройки.Параметры.Свойство(ИмяТеста()) Тогда
		ВыполнятьТест = Настройки.Параметры[ИмяТеста()];	
	КонецЕсли;
	
	Возврат ВыполнятьТест;

КонецФункции

&НаСервереБезКонтекста
Функция Отчеты(ПрефиксОбъектов, ОтборПоПрефиксу)

	Результат = Новый Массив;
	
	Для Каждого Отчет Из Метаданные.Отчеты Цикл
		Если ОтборПоПрефиксу И Не ИмяСодержитПрефикс(Отчет.Имя, ПрефиксОбъектов) Тогда
			Продолжить;
		КонецЕсли;
		СтруктураОтчета = Новый Структура;
		СтруктураОтчета.Вставить("Имя", Отчет.Имя);
		СтруктураОтчета.Вставить("Синоним", Отчет.Синоним);
		СтруктураОтчета.Вставить("ПолноеИмя", Отчет.ПолноеИмя());
		Результат.Добавить(СтруктураОтчета);
	КонецЦикла;	
	
	Возврат Результат;

КонецФункции 

&НаКлиентеНаСервереБезКонтекста
Функция ИмяСодержитПрефикс(Имя, Префикс)
	
	Если Не ЗначениеЗаполнено(Префикс) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ДлинаПрефикса = СтрДлина(Префикс);
	Возврат СтрНайти(ВРег(Лев(Имя, ДлинаПрефикса)), ВРег(Префикс)) > 0;
	
КонецФункции

#КонецОбласти