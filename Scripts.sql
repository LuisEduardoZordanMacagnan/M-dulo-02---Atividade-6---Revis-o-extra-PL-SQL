--1
CREATE OR REPLACE PROCEDURE add_employee 
    (v_first_name IN VARCHAR2,
    v_last_name IN VARCHAR2, 
    v_job_id IN VARCHAR2, 
    v_salary IN NUMBER, 
    v_department_id IN NUMBER) IS
BEGIN
	INSERT INTO EMPLOYEES
		(FIRST_NAME, LAST_NAME, HIRE_DATE, JOB_ID, SALARY, DEPARTMENT_ID)
	VALUES
		(v_first_name, v_last_name, SYSDATE, v_job_id, v_salary, v_department_id);
	DBMS_OUTPUT.PUT_LINE('Funcionário '||v_first_name||' '||v_last_name||' inserido com sucesso!');
END add_employee;

--2
CREATE OR REPLACE PROCEDURE update_salary 
    (v_job_id IN VARCHAR2,
    v_percentage IN NUMBER) 
IS
    v_qnt_afetados NUMBER(7);
BEGIN
    SELECT COUNT(*) INTO v_qnt_afetados FROM EMPLOYEES WHERE JOB_ID LIKE v_job_id;
    IF v_percentage>0 THEN
    	UPDATE EMPLOYEES SET
    		SALARY = SALARY+SALARY*(1+v_percentage/100)
    	WHERE
    		JOB_ID LIKE v_job_id;
    ELSE
    	UPDATE EMPLOYEES SET
    		SALARY = SALARY-SALARY*(1+(v_percentage*-1)/100)
        WHERE
            JOB_ID LIKE v_job_id;
	END IF;
	DBMS_OUTPUT.PUT_LINE(v_qnt_afetados||' foram afetados!');
END update_salary;

--3
CREATE OR REPLACE PROCEDURE delete_employees_by_dept 
    (v_department_id IN NUMBER) 
IS
    v_qnt_excluidos NUMBER(7);
	v_mensagem VARCHAR2(100);
BEGIN
    v_qnt_excluidos := 0;
    SELECT COUNT(*) INTO v_qnt_excluidos FROM EMPLOYEES WHERE DEPARTMENT_ID = v_qnt_excluidos;
	IF v_qnt_excluidos>0 THEN
        v_mensagem := v_qnt_excluidos||' foram excluídos';
        DELETE FROM EMPLOYEES WHERE DEPARTMENT_ID = v_qnt_excluidos;
    ELSE
        v_mensagem := 'Ninguém excluído!';
	END IF;
	DBMS_OUTPUT.PUT_LINE(v_mensagem);
END delete_employees_by_dept;

--4
CREATE OR REPLACE FUNCTION calculate_annual_salary (v_salary IN NUMBER) RETURN NUMBER IS
BEGIN
    RETURN (v_salary*12);
END;
BEGIN
    DBMS_OUTPUT.PUT_LINE(calculate_annual_salary(3000));
END;

--5
CREATE OR REPLACE FUNCTION get_full_name (v_employee_id IN NUMBER) RETURN VARCHAR2 IS
    v_nome_completo VARCHAR2(300);
BEGIN
    FOR e IN (SELECT FIRST_NAME, LAST_NAME FROM EMPLOYEES WHERE EMPLOYEE_ID = v_employee_id) LOOP
		v_nome_completo := e.FIRST_NAME||' '||e.LAST_NAME;
    END LOOP;
    RETURN (v_nome_completo);
END;

--6
CREATE OR REPLACE FUNCTION is_department_available (v_department_id IN NUMBER) RETURN VARCHAR2 IS
    v_qnt NUMBER(7);
BEGIN
    v_qnt := 0;
    SELECT 
        COUNT(*)
    INTO
    	v_qnt
    FROM
        EMPLOYEES
    WHERE 
        DEPARTMENT_ID = 90
    GROUP BY
        DEPARTMENT_ID;
    IF v_qnt > 0 THEN
        RETURN 'YES';
    ELSE
    	RETURN 'NO';
    END IF;
END;

--7
CREATE OR REPLACE PROCEDURE transfer_employee (v_employee_id IN NUMBER, v_new_department_id IN NUMBER) IS
    v_verificao NUMBER(1);
BEGIN
    v_verificao := 0;
    SELECT COUNT(*) INTO v_verificao FROM EMPLOYEES WHERE EMPLOYEE_ID = v_employee_id;
	IF (v_verificao>0) THEN
    	UPDATE EMPLOYEES SET
        	DEPARTMENT_ID = v_new_department_id
        WHERE EMPLOYEE_ID = v_employee_id;
	ELSE
        DBMS_OUTPUT.PUT_LINE('Usuário inválido!');
	END IF;
END transfer_employee;

--8
CREATE OR REPLACE FUNCTION get_employee_count_by_dept (v_department_id NUMBER) RETURN NUMBER IS
	v_total NUMBER(7);
BEGIN
    SELECT COUNT(*) INTO v_total FROM EMPLOYEES WHERE DEPARTMENT_ID = v_department_id GROUP BY DEPARTMENT_ID;
	RETURN v_total;
END;