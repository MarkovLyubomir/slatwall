<?xml version="1.0" encoding="UTF-8"?>
<validateThis xsi:noNamespaceSchemaLocation="validateThis.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<contexts>
		<context name="save" />
		<context name="delete" />
		<context name="edit" />
	</contexts>
	<objectProperties>
		<property name="amount">
			<rule type="required" contexts="save" />
		</property>
		<property name="paymentMethod">
			<rule type="required" contexts="save" />
		</property>
		<property name="accountPaymentType">
			<rule type="required" contexts="save" />
		</property>
	</objectProperties>
</validateThis>