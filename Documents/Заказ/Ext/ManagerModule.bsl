﻿#Область ПрограммныйИнтерфейс

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|  ЗначениеРазрешено(Организация)
	|И ЗначениеРазрешено(Ответственный)";
	
КонецПроцедуры

#КонецОбласти
