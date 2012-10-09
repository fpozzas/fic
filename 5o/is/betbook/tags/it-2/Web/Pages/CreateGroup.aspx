<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CreateGroup.aspx.cs"
    Inherits="Es.Udc.DotNet.Betbook.Web.Pages.CreateGroup" MasterPageFile="~/Betbook.Master" %>

<asp:Content ID="content" ContentPlaceHolderID="ContentPlaceHolderMain" runat="server">
    <div id="form">
        <form id="CreateGroupForm" method="post" runat="server">
        <div class="field">
            <span class="label">
                <asp:Localize ID="lclGroupName" runat="server" meta:resourcekey="lclGroupName" />
            </span>
            <span class="entry"><asp:TextBox ID="txtGroupName" runat="server" 
                Width="200px" Columns="16"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvGroupName" runat="server" ControlToValidate="txtGroupName"
                    Display="Dynamic" Text="<%$ Resources: Common, mandatoryField %>" 
                CssClass="errorMessage"></asp:RequiredFieldValidator>
                <asp:Label ID="lblCreateGroupError" runat="server" ForeColor="Red" Style="position: relative"
                    Visible="False" meta:resourcekey="lblCreateGroupError">                        
                </asp:Label>
            </span>

        </div>
        <div class="field">
            <span class="label">
                <asp:Localize ID="lclGroupDesc" runat="server" meta:resourcekey="lclGroupDesc" />
            </span>
            <span class="entry">
                <textarea id="txtareaGroupDesc" runat="server" cols="20" name="S1" rows="4" />
                <asp:RequiredFieldValidator ID="rfvGroupDesc" runat="server" ControlToValidate="txtareaGroupDesc"
                        Display="Dynamic" Text="<%$ Resources: Common, mandatoryField %>" 
                    CssClass="errorMessage"></asp:RequiredFieldValidator>
            </span>
        </div>
        <div class="field">
            <asp:Button ID="btnCreateGroup" runat="server" meta:resourcekey="btnCreateGroup" 
                OnClick="btnCreateGroup_Click" />
        </div>
        </form>
    </div>
    <br />
    <br />
</asp:Content>
