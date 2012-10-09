<%@ Page Language="C#" MasterPageFile="~/Betbook.Master" AutoEventWireup="true"
CodeBehind="RecommendEvent.aspx.cs" Inherits="Es.Udc.DotNet.Betbook.Web.Pages.RecommendEvent" %>

<asp:Content ID="content" ContentPlaceHolderID="ContentPlaceHolderMain" runat="server">
    <br />
    <p>
        <asp:Label ID="lblNoUserGroups" meta:resourcekey="lblNoUserGroups" runat="server"></asp:Label>
    </p>
    <form id="form" runat="server" enableviewstate="false" >
        <div class="field">
            <span class="label">
                <asp:Localize ID="lclRecommendationDesc" runat="server" meta:resourcekey="lclRecommendationDesc" />
            </span>
            <span class="entry">
                <textarea id="txtareaRecommendationDesc" runat="server" cols="20" name="S1" rows="4" />
                <asp:RequiredFieldValidator ID="rfvRecommendationDesc" runat="server" ControlToValidate="txtareaRecommendationDesc"
                        Display="Dynamic" Text="<%$ Resources: Common, mandatoryField %>" 
                    CssClass="errorMessage"></asp:RequiredFieldValidator>
            </span>
        </div>
    
        <p>
            <asp:Label ID="lblGroupsGrid" meta:resourcekey="lblGroupsGrid" runat="server"></asp:Label>
        </p>
        <p>
            <asp:Label ID="lblNoGroupsSelected" visible="false" CssClass="errorMessage"
            meta:resourcekey="lblNoGroupsSelected" runat="server"></asp:Label>
        </p>
        <asp:GridView ID="gvShowUserGroups" runat="server" CssClass="cooltable" GridLines="None"
            AutoGenerateColumns="False" DataKeyNames="groupId" >
            <Columns>
                <asp:BoundField DataField="name" meta:resourcekey="colGroupName"  />
                <asp:TemplateField meta:resourcekey="colGroupCreator">
                    <ItemTemplate>
                        <asp:Label 
                        ID="lblGroupCreator" 
                        runat="server"
                        Text='<%# ((Es.Udc.DotNet.Betbook.Model.User)Eval("user")).login %>' />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="description" meta:resourcekey="colGroupDesc" />
                <asp:TemplateField meta:resourcekey="colCheckboxRecommend">
                    <ItemTemplate>
                       <asp:CheckBox ID="chkSelect" runat="server" EnableViewState="true"/>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
        <div class="field">
        <asp:Button ID="Recommend" runat="server" meta:resourcekey="btnRecommend"
           OnClick="btnRecommend_Click" />
        </div>
    </form>
    <br />
    <br />
</asp:Content>