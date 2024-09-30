       IDENTIFICATION                  DIVISION.
       PROGRAM-ID.                     TRANSACTION_LOGGER.

       ENVIRONMENT                     DIVISION.
       CONFIGURATION                   SECTION.

       INPUT-OUTPUT                    SECTION.
       FILE-CONTROL.

           SELECT CUSTOMERFL           ASSIGN TO "CustomerInfo.TXT"
           ORGANIZATION IS LINE SEQUENTIAL.

           SELECT TRANSACTIONFL        ASSIGN TO "TransactionData.TXT"
           ORGANIZATION IS LINE SEQUENTIAL.

       DATA                            DIVISION.
       FILE                            SECTION.

       FD  CUSTOMERFL.
       01  CUSTOMERFL-REC.
           05 CUST-ID                  PIC 9(13).
           05 CUST-FULLNAMES           PIC X(40).
           05 CUST-CELLNO              PIC 9(10).
           05 CUST-ADDRESS             PIC X(30).
           05 CUST-EMAIL               PIC X(25).
           05 CUST-PPROFESSION         PIC X(20).
           05 CUST-CREDITSCORE         PIC 9(04).

       FD  TRANSACTIONFL.
       01  TRANSACTIONFL-REC.
           05 T-CUST-ID                PIC 9(13).
           05 T-TYPE                   PIC X(15).      *> (Deposit, Withdrawal, Loan)
           05 T-AMOUNT                 PIC 9(10).      *> Amount of transaction
           05 T-LOAN-PURPOSE           PIC X(30).      *> Purpose of loan if applicable
           05 T-INTEREST-RATE          PIC 9(3)V99.    *> Interest rate on loan or deposit
           05 T-LOAN-AMT               PIC 9(10).      *> Loan amount if applicable
           05 T-FIXED-DEPOSIT-AMT      PIC 9(10).      *> Amount in fixed deposit

       WORKING-STORAGE                 SECTION.
       01  WS-EOF                      PIC XX.

       PROCEDURE                       DIVISION.

       MAIN-PROCEDURE.

           PERFORM BA000-INIT.
              PERFORM UNTIL WS-EOF     = HIGH-VALUES

                  DISPLAY CUSTOMERFL-REC
                  DISPLAY "=========================================="

                  PERFORM ZA000-READ-CUSTOMERFL
                  PERFORM ZA000-READ-TRANSACTIONFL

           END-PERFORM

           DISPLAY "==> TRANSACTION_LOGGER RAN"

           CLOSE CUSTOMERFL TRANSACTIONFL.
           STOP RUN.

       BA000-INIT                      SECTION.

          MOVE LOW-VALUES             TO WS-EOF.

          OPEN INPUT                  CUSTOMERFL
                                      TRANSACTIONFL.

          PERFORM ZA000-READ-CUSTOMERFL.
          PERFORM ZA000-READ-TRANSACTIONFL.

      ******************************************************************
      * Section for reading CUSTOMERFL
      ******************************************************************
        ZA000-READ-CUSTOMERFL           SECTION.

          READ CUSTOMERFL
            AT END
           MOVE HIGH-VALUES       TO WS-EOF.

      ******************************************************************
      * Section for reading TRANSACTIONFL
      ******************************************************************
       ZA000-READ-TRANSACTIONFL        SECTION.

          READ TRANSACTIONFL
            AT END
           MOVE HIGH-VALUES       TO WS-EOF.
