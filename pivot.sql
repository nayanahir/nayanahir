select FirstName,[HR],[Admin],[Account] from
	(
		select FirstName,
		Department,
		Salary 
		from mstEmployee
	) as abc
	pivot
	(
		sum(Salary)
		for Department
		in ([HR],[Admin],[Account])
	) as pivottbl
